Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LLQhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:37:12 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56227 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3LLQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:37:08 -0500
Date: Thu, 12 Dec 2013 08:37:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.13-rc3
Message-ID: <20131212163701.GA402@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive more updates for the input subsystem. You will get a fix for
recent sysfs breakage in serio subsystem plus a fixup to adxl34x driver.

Changelog:
---------

Dmitry Torokhov (1):
      Input: serio - fix sysfs layout

Michael Hennerich (1):
      Input: adxl34x - Fix bug in definition of ADXL346_2D_ORIENT


Diffstat:
--------

 drivers/input/misc/adxl34x.c |  2 +-
 drivers/input/serio/serio.c  | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)


--=20
Dmitry


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqeYtAAoJEH70+W8r6ZYqUCsQAIcAYbxQoYYFuw4XMM1oG8Kc
3mlGc0QmHHK8WwXCcQ7GNWMGWb8Qu6usJrhLa3PX4ueJRm7p0L9t2fhUBECXMaPV
mDvIoSjZE/wOFEIh6zZawxBMpwDB2RAODIXPcvc1r5GgX69De6VYV5sE6zdAy+u+
FAPu39R3yS38+QUSbdsUNkc3DSiL4tz1cPRYqNegyVWMq8fkLqz6dwdRovgF7+wc
Friurdaba00R6iVMkqMFoWFDVwxyz8OVeDe0g+5jWlbzIHo6kd4wHNagl376GJvU
oH8IYFkeo8+56+lXglyQqflPt1IGiJlGFJ/UkZTsyrVZiqQtc4vSsS8cCAw7v1B6
cBO5ucXDIYaKdKjtyOYFcOMriktT/KiAUoZ88rsuFCPBY+7oaEqU7yU4FmO+fDvH
2LpAYnysRsI47REz9w9xZ29V+euE4DO/hoMXMcmkIKic0Z2sc+HllCLtg1nIvDYy
5r8lJHDTYQNeKPL3XszleyNJ7LukhS9WlSR7S+jwq7W9khG0BNPKmIL5BHMpCHmp
HUxabHvCTC1/wKtNS0ZX9D6aT3Zo75XSzf9v4477AQ/DTYKuKysEoJPIcjcHVDe2
LGxaGgT+mQKVS/IKxst8eaJgk71K6xQ6y1ACOPehkiPlHKpfxmlBSod5F3kRPa83
fCWf5Dm3gFoIcclgib3U
=JXeb
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
