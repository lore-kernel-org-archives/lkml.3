Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaEHPwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:52:30 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54113 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaEHPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:52:28 -0400
Date: Thu, 8 May 2014 08:52:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.15-rc4
Message-ID: <20140508155222.GA11231@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a few fixups to various
drivers.

Changelog:
---------

Dr. H. Nikolaus Schaller (2):
      Input: bma150 - extend chip detection for bma180
      Input: tca8418 - fix loading this driver as a module from a device tr=
ee

Hans de Goede (2):
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      Input: elantech - fix touchpad initialization on Gigabyte U2442

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops


Diffstat:
--------

 Documentation/input/elantech.txt        |  5 ++++-
 drivers/input/keyboard/atkbd.c          | 29 ++++++++++++++++++++++++++++-
 drivers/input/keyboard/tca8418_keypad.c |  7 +++++++
 drivers/input/misc/bma150.c             |  4 +++-
 drivers/input/mouse/elantech.c          | 26 +++++++++++++++++++++++++-
 drivers/input/mouse/elantech.h          |  1 +
 drivers/input/mouse/synaptics.c         |  8 ++++++++
 7 files changed, 76 insertions(+), 4 deletions(-)

--=20
Dmitry


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTa6g2AAoJEH70+W8r6ZYq+JkP/iGMxwaE+eJwchvCUOo2KLO3
hTYAEYNd18yf9fK3o4SPILQIZPc9Wvo0gxWoCGsix+ZBIi8Fv+G1NhgI+C2dMSRy
N9i4xAqTvjmgklzbyk1azIdyiUE1xUEidVkhmAWZSO29ml7nIkrdnxi7iyFjkSeS
rwn2mRaAM/eezIn5b4z3yIZ6NgbwxNlGbfE2iBt4HYKU2no+hBISrYRx1K1orqkq
Vo9O5LoXe5lt9LocOcl2HSgGx45pWmi5ByoLhwNxeBnB/wb1vbyGqzqBTdTELKf0
MSR5p0gM3Eeis7Xbtkw0sdSHr1dJUxD4bXfXB0fLwojLSLQbCwYqrbHieNbqHct3
JHaM9vJKP4oPz/IlSRPTY/aKzD+f1HnUfqXOJycXZIsFLOpC4MVGf/z72mYnmAFj
ndOj2t3RuXb939SQG95T00G49ks2sx6fnFF3FuEQuzjZR59SZLCPStSsyVXfD/Ws
wMzIrxOMfMOkrKJunTSlLYDBfuxRdmJ9di5JTSakHwqB1WBPgteWwi/VH7qzZo3N
TmHNvJNBhneA1Wgr4jT/TRGeGhy9SMT2hZYFpHJwVN2TcvOueD4p/FbRzXJ/NThS
fGctRS2orYz+C6vK2h3BXz1WqsEz34gjxN1IXOvoWQ5b1HrtN4LKS4bxSsqvxs8y
ilnGfs/fROqOQoLMDMVX
=ZAK1
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
