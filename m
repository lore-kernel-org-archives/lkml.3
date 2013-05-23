Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3EWQRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:17:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44824 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499Ab3EWQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:17:15 -0400
Date: Thu, 23 May 2013 09:17:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.10-rc2
Message-ID: <20130523161711.GA8745@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a few fixups to
Wacom and eGalax touchscreen driver.

Changelog:
---------

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Ping Cheng (3):
      Input: wacom - add three new display tablets
      Input: wacom - add a few new styli for Cintiq series
      Input: wacom - add an eraser to DTH2242/DTK2241


Diffstat:
--------

 drivers/input/tablet/wacom_wac.c      | 89 ++++++++++++++++++++++++++-----=
----
 drivers/input/tablet/wacom_wac.h      |  1 +
 drivers/input/touchscreen/egalax_ts.c |  2 +-
 3 files changed, 69 insertions(+), 23 deletions(-)

--=20
Dmitry


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRnkEHAAoJEH70+W8r6ZYqOqoQAJ+9Aq+FLG4h9jveKL9JFdH3
Ln0vWOmYsp0+ENOB73bvgtx31PzHCXtB6kiS3oatabbIaomCZF4Fa6SYzGBBMJt6
duZLIdqxAzpFeF/MgI+InilEipD0Ev8tqC/e6PB4tPxcxX+x3JyL64eTJCxsH4VO
7VYFalok+nUn2LzVPNTGB2SZ5Onpk9jJ+aVggBHIDfnBTAcvSZ//UhOlfqCYxeKx
aNqc38wL5KVwIuzGNJDVQ7ot170GzeMLvwlHRaWGuh7RA9AcqvfuEiyZDYifYzgU
9rgNg6ZKIFg2tZYKtGevwjdLpIwKgPR3kspLDUSGSwcS/eNO6Vu3qhqsHtM3y+Ry
kvC0lb9a/U9LQMC26OWS3xQto+SU3ReC712hvbJFK1lPMkWH+yYXCBtog+g9zkhI
eZGm+MImciYH28H36gu90GV1YiV19bpwk71tzawtznnCINqyQPGZoyavzZSVHk20
EV8WwvmCXv1K0H0ccDDnOL3dQU6FjbNqRIzoj4Dlyf6jCkLgucDKzT5mX7ai1bwZ
etnKYPHiiIEwbeibMTMd1Ve4Fv5xQmez25Dby1TtnzlnN8C436P4lGizgOmZ38dG
IfFLvzUjMY7S9xkMskDkcOMU9957VFhvIYnDwhLvXGfbYLGJtB/52//fXxNUe2aU
yj4MspYOVf3zFP4c0Roo
=G0B5
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
