Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3IOFeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 01:34:21 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41859 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3IOFeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 01:34:19 -0400
Date: Sat, 14 Sep 2013 22:34:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.12-rc0
Message-ID: <20130915053415.GA9577@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The only change is David
Hermann's new EVIOCREVOKE evdev ioctl that allows safely passing file
descriptors to input devices to session processes and later being able
to stop delivery of events through these fds so that inactive sessions
will no longer receive user input that does not belong to them.

Changelog:
---------

David Herrmann (1):
      Input: evdev - add EVIOCREVOKE ioctl


Diffstat:
--------

 drivers/input/evdev.c      | 37 +++++++++++++++++++++++++++++++------
 include/uapi/linux/input.h |  1 +
 2 files changed, 32 insertions(+), 6 deletions(-)

--=20
Dmitry


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSNUbWAAoJEH70+W8r6ZYqqVMP/159JOloVUDV2uO9kCOB2Zlz
ZFwbcXHxiqChXgZYh3+HdkLse74u10vjLxibiE0CcFM0ubIKazVxvPYlzkXTa5OB
SAy2e1X1I/WyoCSZnG0fLMF5murL7D2/q9KPHQObYgbHau+WfJRqbrZYHbCLz7rC
MnIk+On1ohDngiaos7kLpZEW6rpRh1TpPMsH5gmoVyjKXuQChajfNLBe+Ed7AJYC
DXK6xmGyX3Jdgo6APfaYZeFDgJZUmiui/gt74bqKlfRZbVuvzk9la0GDgoQVvOjJ
PW9q3nylzEkTBIWF2vKS8vTg7OjcF3dZsDJjzh4lKDP5pSH4ChELt4iWtHqyyZTz
cd6O2oYkKO5ROF7/Cp0nGWw49HDW2SQ+CBAfY647Lo7+4UfyhNhkBIaV4kwF2XFv
b3tISpIwkVLC6a0lrAPU8cVeZGrrzr6tCyET7MebBzkQ9Q8kvdj/IAE6uPrlK0pU
nFnfd+GFaQnD9cN4dd166tftezz8CUKkAabsVLsc+Vm6GfCCICvr4fyQByFFS0mj
p830x2I/FsTqPbGyauzkeKhfp6wE2FV5JPa+Q+snzmFY7bXrp3TtEylzmY+0+akV
ZT96yPFo5n1uEABmRaqlymM0Fr8ylUo02XPf0bpSZqsaf9HL6VPJydu/j4efwsl2
DR2tjQFB/broktrShOt3
=gHrj
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
