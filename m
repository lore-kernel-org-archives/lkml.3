Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaIJEO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:14:59 -0400
Received: from ozlabs.org ([103.22.144.67]:49187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaIJEO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:14:57 -0400
Date: Wed, 10 Sep 2014 14:14:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        viresh kumar <viresh.kumar@linaro.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: linux-next: manual merge of the pm tree with the arm-soc tree
Message-ID: <20140910141450.49d692c1@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/O23jWnfOGKUTkil6LgpgvaA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O23jWnfOGKUTkil6LgpgvaA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next merge of the pm tree got a conflict in
arch/arm/mach-shmobile/board-ape6evm-reference.c between commit
664b4c172209 ("ARM: shmobile: ape6evm: Remove duplicate CPUFreq bits")
from the arm-soc tree and commit 978027e170fb ("cpufreq: cpu0: rename
driver and internals to 'cpufreq_dt'") from the pm tree.

I fixed it up (the former removed the line updated by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/O23jWnfOGKUTkil6LgpgvaA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD9A+AAoJEMDTa8Ir7ZwVmrAQAJHUaCchMOReqocLua3l3gy6
u4h09x/rAfr2eMPwjQMUzK/0a9d3ldLzFtdmrStVwjaXLK/YtNhEyJjn4iTpPuIb
yzwKTB8y3DY5/jgbcoby7wiHsmzmaNXrMpkfMNMq1VfU+jiqKvK5uK/gQm4AzTXu
TkWX3XLCyQ3y1WZ9VZGGhcKRKB/MlbAKzPPN2CD1QR11QGKNWSXJuLZglrCd+bdU
nOFZHMRP+YJTdbSrCDh/wnKweTT2TxST2DkrjDa4oXzYM7uXNoMVCrbe0ITyyovx
sjEw0venmY61WolarzL1W3e3JkO6uBhReAPDPxYNK06gOwkkpNj893fxnEV1VlYq
e7Qu0rkWaq3BIAqtpo0g8YLVk20GiYh0H0y4uwizfJoOt89L04dWzLayRlQ0YL2G
TFACDUQk+kVPvtKjH7lT5l8U30+QCgQ6Y26m+ykhEbWYhIHUyNQuZ5zbyYEmJHAJ
cLXrCjbYsH92oFmN3IOFu1n7/y0+vT8rjfasQHXbxZRV2fq+fb0aEJX1JOYV+BYg
KkNCcEq0ECZqwqMgVRblPz+FeKqOjQ3PxUtMX8Kxnc9NhnegUaToXXqeiwhpsVF+
+iMM3UleligVI2TW6nrgb9TS8426v2/BAmADSRs6nO5kfKc5x6+B2BL97DsvMDHd
xvdf2u6WNixoV5RPbq0d
=68nW
-----END PGP SIGNATURE-----

--Sig_/O23jWnfOGKUTkil6LgpgvaA--
