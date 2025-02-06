import sys
import re

def convert_transcript_to_timeline(input_file_path, output_file_path):
    """
    Converts a transcript file to a timeline command file for a game engine.

    Args:
        input_file_path (str): Path to the input transcript file.
        output_file_path (str): Path to the output timeline command file.
    """

    character_aliases = {
        "C1": "character01",  # Character01、ステンMK-II
        "C2": "character02",  # Character02、スコーピオン
        "T": None,           # Narrator (no character)
    }

    animation_names = {
        "bump": "Bump",
        "slideinleft": "Slide In Left",
        "slideinright": "Slide In Right",
        "tada": "Tada",
        "shakex": "Shake X",
    }

    current_characters_on_screen = set()
    # last_time = 0.0, wait_time uses timepoint, not time length, not needed

    with open(input_file_path, 'r', encoding='utf-8') as infile, open(output_file_path, 'w', encoding='utf-8') as outfile:
        outfile.write("[music path=\"res://assets/musics/demo01.ogg\" fade=\"0.0\" volume=\"0.0\" loop=\"false\"]\n")
        outfile.write("[background arg=\"res://assets/backgrounds/background_1.png\" fade=\"0.0\"]\n\n")

        outfile.write("[wait_time]\n") # initial wait time

        for line in infile:
            line = line.strip()

            if not line or line.startswith('#'): # TODO: allow empty spaces in a empty line
                continue

            match = re.match(r'(\d+):(\d+\.?\d*)\s+([A-Z0-9\+]+)(?::([a-zA-Z]+))?(?::\"([^"]*)\")?\s+(.*)', line)
            if not match:
                print(f"Warning: Invalid line format: {line}")
                continue

            minutes = int(match.group(1))
            seconds = float(match.group(2))
            time_in_seconds = minutes * 60 + seconds
            character_code = match.group(3)
            animation_code = match.group(4)
            display_name = match.group(5)
            text = match.group(6)

            wait_time = time_in_seconds # - last_time
            if wait_time > 0:
                outfile.write(f"[wait_time time=\"{wait_time:.1f}\"]\n")
            # last_time = time_in_seconds

            character_codes = character_code.split('+')
            # TODO: here two characters duplicates text lines, will deal later

            for char_code in character_codes:
                char_alias = character_aliases.get(char_code)

                if char_alias:
                    if char_alias not in current_characters_on_screen:
                        join_animation = "Slide In Left" if char_code == "C1" else "Slide In Right" # default join animation
                        outfile.write(f"join {char_alias} {'left' if char_code == 'C1' else 'right'} [animation=\"{join_animation}\"]\n")
                        current_characters_on_screen.add(char_alias)
                    elif animation_code or char_alias in current_characters_on_screen:
                        animation_name = animation_names.get(animation_code, "Tada") # default update animation is Tada
                        outfile.write(f"update {char_alias} [animation=\"{animation_name}\" length=\"0.8\"]\n")


            output_text_line = ""
            if character_aliases.get(character_code) is not None: # is not narrator
                output_text_line += f"{character_aliases.get(character_code)}: "
            output_text_line += "[aa]" # auto show and step to next text
            output_text = text.replace('\n', '\\\n') # handle line breaks
            output_text_line += output_text
            outfile.write(output_text_line + "\n")

        outfile.write("[wait]\n")
        outfile.write("leave --All--\n") # scene end, leave all characters
        # TODO: other finishing jobs
        current_characters_on_screen = {} # TODO: deal with leaving in the middle of the scene, and multiple characters


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script_name.py <input_file_path> <output_file_path>")
        sys.exit(1)

    input_file_path = sys.argv[1]
    output_file_path = sys.argv[2]

    convert_transcript_to_timeline(input_file_path, output_file_path)
    print(f"Successfully converted '{input_file_path}' to '{output_file_path}'")
