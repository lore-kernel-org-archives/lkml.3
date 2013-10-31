Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3JaIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:08:37 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56394 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3JaIIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:08:34 -0400
Date: Thu, 31 Oct 2013 01:08:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.12-rc7
Message-ID: <20131031080831.GA25525@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. A bit late than I would
want, but the changes are very minor - a few new device IDs for new
hardware in existing drivers, fix for battery in Wacom devices not be
considered system battery and cause emergency hibernations, and a couple
of other bug fixes.

Changelog:
---------

Andrey Moiseev (1):
      Input: i8042 - i8042_flush fix for a full 8042 buffer

Bastien Nocera (1):
      Input: wacom - export battery scope

David Herrmann (1):
      Input: move name/timer init to input_alloc_dev()

Jason Gerecke (2):
      Input: wacom - add support for ISDv4 0x10F sensor
      Input: wacom - add support for ISDv4 0x10E sensor

Mike Dunn (1):
      Input: pxa27x_keypad - fix NULL pointer dereference

Tim Gardner (1):
      Input: cm109 - convert high volume dev_err() to dev_err_ratelimited()

Yunkang Tang (1):
      Input: ALPS - add support for model found on Dell XT2


Diffstat:
--------

 drivers/input/input.c                  | 10 +++++-----
 drivers/input/keyboard/pxa27x_keypad.c | 11 +++++++++--
 drivers/input/misc/cm109.c             | 14 ++++++++++----
 drivers/input/mouse/alps.c             |  1 +
 drivers/input/serio/i8042.c            | 23 ++++++++++++++---------
 drivers/input/tablet/wacom_sys.c       |  4 ++++
 drivers/input/tablet/wacom_wac.c       |  8 ++++++++
 7 files changed, 51 insertions(+), 20 deletions(-)

--=20
Dmitry


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScg//AAoJEH70+W8r6ZYqMXsQAKiLzHCpj+LChytQbUVn8bYG
LsSClzc653t3uAzf2Ha/i4vkmGnnop64b9wDxZVDFK36p9L5oZw8ZF9BRxpWV+Pr
/RQ5i/ax3YvrcMUs5gLuEOPatRpPRfHCxUD/NFlB+873QH6J+ngwiURttSMEhzE/
tmRw57BT5v0yOIsSGDtHwAdv+/M3ocFCb1VrpmjT4CktSt7F2V5/ZiomvSUiIzZT
/JkJhvJ8Uwjq1nk5bXQ562fSFpTRoBrS/vbPAIF9+XwHpXCRzmKUzt8DEZmm+1xR
+fdKJn3ZIuDfGY4XPr6zUhOpdIe6GvRTfAvV9dI4Gfgf/78rcJp6UWSN0z4/P/UO
bcAw381PxxWo/kOagXfnsinQIMzQEdC9Hgvl2syXjyo6f8S3HvpGiQ6qOP+d2681
SqktomwBkWwyy2iQum2a9D//a9U7GC+KNOJWZ7xnNVISMfKxggO+Cqd/D9f38p2s
jiJd1MA58uPaFrorGTc8ft7oSMk5M6vMUfpKQTH0q219a2GD5U/jTRjwiZ379ja6
lTL8SfZpX7/142Kyrr27k5mt1LR0a55tCA3TnTesXLh7Z8d9Wvd86LrZ/67CQLJm
Rf0yYPeVyq/Rae4mGA9yvrZsyiyV7i4xG2E9P+o5UYXAbQOq/3hSg7RklA6JVtEH
vpEGA7lo9jLPzEjSIljy
=quWC
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
