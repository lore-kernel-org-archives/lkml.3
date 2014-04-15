Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaDOBtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:49:31 -0400
Received: from ozlabs.org ([103.22.144.67]:51567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaDOBt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:49:29 -0400
Date: Tue, 15 Apr 2014 11:49:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20140415114923.f00275d51f12e3a988f346b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_11_49_23_+1000_xWiMWOTLwQ3W/RZk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_11_49_23_+1000_xWiMWOTLwQ3W/RZk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

sound/soc/fsl/fsl_ssi.c: In function 'fsl_ssi_probe':
sound/soc/fsl/fsl_ssi.c:1471:2: error: implicit declaration of function 'of=
_find_node_by_path' [-Werror=3Dimplicit-function-declaration]
  sprop =3D of_get_property(of_find_node_by_path("/"), "compatible", NULL);
  ^

Probably caused by commit eba9e06f0ceb ("ASoC: fsl: Separation of the
main audio options and boards").

I have used the sound-asoc tree from next-20140414 for today.
--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Tue__15_Apr_2014_11_49_23_+1000_xWiMWOTLwQ3W/RZk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTJAoAAoJEMDTa8Ir7ZwVWQ4P+wTNjr7Bi1lnF6q4FTzQ17eT
yqFxz2Hircp3NgLfpHN+lg9FpazrNPufv2AddnVaUVQ76jkzl0XUCumBlZuHWYcE
hmRB7k0ZA/Zkoxr8AZ/uikF9MIxaa+B/iy7KS+mtbkEBMWMvjMiLY9rKJk5k/jzD
oT6xFwYWsRASTAUsOEokFM6Omi64IaALK438pd5izUFlyyxCHBKZXByEbMlG+vok
w3B0VTGKvCWb3FBkO9ZDr1I580br9g2E21P0zME470JdwmGP9jWQMT86N/U54Hhw
m/LsFTsr+/pQiqDGlurO10W7a2oblvcETZgU2oQ2cPprAseG1QPioQTEauhgv1T4
6gD91ldT1ht65r2Ujh6eRrWzodrVc7wzLufhgCWakgtWjfNJjOqsWwtLbj+eELbU
0Z/i9Ij6A/ryCNB1sMwm809wVWqpaqvTAVBRiPmU1GK719dvQhMPn7yKmeOQycGp
s8oiD5PnPl+K9ZLq/vZEU62w7WyqJq/zZDB8RjtLVy2JOh4EUQodTUqKyOlh5Phg
E5C1elkxEyAHBNgIJkXEBzSLhJRFVqNjyatlpX6AU1RXKxI94iXOHpWOvpzjRBbs
ERJXHCGCL1XZ29rh5h0imUoF3J/xzM3H2xeEKj8jwZNwxju9GYbdnvePoxpESpQQ
HPiDpLOsRH+pf8KwtcgN
=RiJs
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_11_49_23_+1000_xWiMWOTLwQ3W/RZk--
