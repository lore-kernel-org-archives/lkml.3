Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaCaCBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:01:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaCaCBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:01:15 -0400
Date: Mon, 31 Mar 2014 13:01:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20140331130107.93488407b1f13f9d64679979@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__31_Mar_2014_13_01_07_+1100_t8gcBkZ1C9/Zvnj2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2014_13_01_07_+1100_t8gcBkZ1C9/Zvnj2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_resume':
drivers/media/usb/em28xx/em28xx-dvb.c:1645:7: error: 'client' undeclared (f=
irst use in this function)
   if (client) {
       ^

Caused by commit 37571b163c15 ("[media] em28xx-dvb: fix PCTV 461e tuner
I2C binding").  Basic build testing is a good idea :-(

I have used the v4v-dvb tree from next-20140328 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__31_Mar_2014_13_01_07_+1100_t8gcBkZ1C9/Zvnj2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOMxnAAoJEMDTa8Ir7ZwV5IkQAIw90nW1YLLD1ZJVZseh46a/
0VF8XpqieVCPRd7+4sF+mhxwBGnGO30Z4hTtASG4E80Ug7NGNPq1qqxrdL3iYYSz
zeB8gUB1aG0kUIzwQWRT7rjnWd0y18+DCe6a1I8Yf0wknWV9L89KX1Of9uplghDc
2sMVKGR8FEb1r3YOR/MO1MB6nWx2PSJ4wYhxbfWmOCiyTJBEeKAIyup//Kd+TXmL
2lWGxMWoZUm/cl7zGO3oD8z3M2VHkNC9WkOTuSCfCJDyHsuGdeIdsUkSEFRENEa4
2XzrINxfIZOlJUCJhmyxCjJgttEUWRU2Jdcats0g05ecbpibH7W9izRaWBa6iAQq
DxrOYu0FF/l99zCEuHfgDNnytXI0PrrAdE982mb5Rc97eBY0IeW2IjB9LVKKjDM6
LvdxICH3CieHxWn8XLHiO2LTENQAhgLAYjoZ9a9DH9jWh1WwMNLMNVyq1rlmgzub
gIneNJJbh1JojtuYitKApTY6EnnSXlDnd6kNPggCkU/3sztJEnsILfg89tilvs7z
eudNZ4Ie1oX2Uv9sNMUPxpeG5LButn+Dwd1ymvjytLAmqaUeFmb5NO9jdSBFCKcO
I0gQEGS+i5dfk/2gGhYArS+dmPKwwKYySx3umvcEVXvNx2IjxUfI4XhdONxur5cS
HRJzssjOnNxPAgAn844B
=Dei6
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2014_13_01_07_+1100_t8gcBkZ1C9/Zvnj2--
