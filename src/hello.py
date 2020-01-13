#!/usr/bin/env python
""" Demo app """

import requests


THREEPG_URL = "https://3pillarglobal.com"


def threepg_up():
    """ Return threepg status code """
    return requests.get(THREEPG_URL).status_code


def main():
    """ Main, of course"""

    print("Hello world")

    print("Is {} up?".format(THREEPG_URL))
    if threepg_up() in range(200, 399):
        print("Yay")
    else:
        print("Nay")

    print("Goodbye")


if __name__ == "__main__":
    main()
