Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3DOQPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:15:55 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:59328 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3DOQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:15:53 -0400
Date: Mon, 15 Apr 2013 09:15:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.9-rc7
Message-ID: <20130415161540.GB19223@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2 small fixups to the Wacom driver.

Changelog:
---------

Jason Gerecke (2):
      Input: wacom - fix "can not retrieve extra class descriptor" for 24HDT
      Input: wacom - correct reported resolution for Intuos4 Wireless


Diffstat:
--------

 drivers/input/tablet/wacom_wac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--=20
Dmitry


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRbCerAAoJEH70+W8r6ZYqveEQAJu/vhhKUiM5k70Q6wORprY6
9ci6aBx3laV4tXItSaCwCDh6OC9O4pdHk2baUyMFwx2Bgd0jPYsmPQ5ihGZNBD2F
qtNsZIezyklegM1aPvQoS+cd6PKmyqaPW2emA+XvPmhnaH/MZiGPR41ZIyT+uotI
07uxzJFWiCdGHftwiJJ0KiFXp2+aWyOhw3EE/Np3IHCnzAXZRGOKnGu4jjjQH/m8
UEQznKwwRjQPbyiqzpPJfwbGjMho4NMIrjCx5XuGtrWL76ODrFBk9taMx1cFh0CO
YMkk5DTQ+xxP0hXtvLqRZymnFFbE5fVZV42p5cxfLAchjZssCcTCrPX/gOEyT29g
NakIrhBc9Bu4joTLWqAfNqyCdSXkfD3NMfUMYhTFXa1p4NXDhIcevWxVEV0jUKqY
6j5mdXoMTRB8576C3tk60esmHJSDipws8/gcULT4qG3G66yv++DGaAiG0+USJHVR
a0lDKlffbYKJpfgqqE98GKDRsY8IR1a256assPB01Bb7PeIHbK2MbfvbotJfmT8/
gulfHQ3lnA7s6HR3udJqDemNhjM48+XrhUi6BIamq11XRo3ipZON116Mck5DrhCl
qkIJM3pYoV6VxiflNYVydh4prZyMdiBl6eDESnLnk3/xPhFxg++zD72QWWRrFPLW
cg10iNrMS3fXB1P/pNvr
=I/f6
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
