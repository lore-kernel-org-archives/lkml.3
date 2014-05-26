Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaEZGIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:08:09 -0400
Received: from ozlabs.org ([103.22.144.67]:51295 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaEZGIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:08:07 -0400
Date: Mon, 26 May 2014 16:07:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: linux-next: build failure after merge of the clockevents tree
Message-ID: <20140526160759.7ccb7757@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3a93CqgYKFF2zDP=6mmc7DE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3a93CqgYKFF2zDP=6mmc7DE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

After merging the clockevents tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:


drivers/clocksource/timer-sun5i.c: In function 'sun5i_timer_init':
drivers/clocksource/timer-sun5i.c:167:2: error: implicit declaration of fun=
ction 'of_reset_control_get' [-Werror=3Dimplicit-function-declaration]

Caused by commit e50a00be5c42 ("clocksource: sun5i: Add support for
reset controller").

I have used the clockevents tree from next-20140523 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/3a93CqgYKFF2zDP=6mmc7DE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgtpEAAoJEMDTa8Ir7ZwVGD8P/Ahah+Rf9fXUNc/+z0qx64/u
Vfe8+2jinBD0Zf5lv+QS2myVvzV33oKZ0/+Euz5MLLoyPTT7e4k19UrVIdLwSWsr
b4lBCQxl2bmnKuz3X21ycX8CpVhrIp58yYSGaQ3bFDrBGOHf8UVC83Z6/+t+tQLv
Q0zlWAF1MfvW3JCuIEP2PynXcJDJtXWiKhElCoGJIS0akSclgWSvW65gC40+ZFUY
yeXlqz2bVnzxQvag9yTTpxbxOpVxZd57rDPGWmTKW1v0ENienN8vy9Jjv4xPGhNE
9eKCRzKmr4PdNqVUsQgCHbIWZgy+3VAxRTDjhx7UeDjeWdIVYBUO0IX1X8YxvQ7r
JF+A1ndb9IQjXurT6TaoMtXRZ3rUKfmA1EjhL9qi7zM6wbOYxE2tyMdDEMTOgVHf
eEuQwM39hT3pBD7yW0ebWSPRYic4ucyzaPHG6P0KQOxyMTm90iNxmNeBJZuWLUSh
iJdmZNQAQ+uPQQqUM+AmF2Ahil84X5Au4Ti+3dXQXdncR2QM3xW+nshqE8oXhp0I
ccGHeJg4Ix+FTQA7/DSJV/GEVbHVnohxuWXlY+fmNKz/HRUEY7Wm+zlScYGFzsYP
W4ZYkVr6C9moIzF507GPTwD87Qkt9Q9OZYDHg+YxkbCxc6TimsZ41aw/Akb2cP4i
MN+UanV8T8dQVo6CQv/P
=Mt7C
-----END PGP SIGNATURE-----

--Sig_/3a93CqgYKFF2zDP=6mmc7DE--
