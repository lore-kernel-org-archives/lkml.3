Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaDQC5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:57:46 -0400
Received: from ozlabs.org ([103.22.144.67]:33085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaDQC5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:57:45 -0400
Date: Thu, 17 Apr 2014 12:57:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: linux-next: manual merge of the crypto tree with Linus' tree
Message-Id: <20140417125739.30a8730cf42d35dabe2966f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_12_57_39_+1000_DrbgTQ6J4DWrCCx7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_12_57_39_+1000_DrbgTQ6J4DWrCCx7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
drivers/crypto/bfin_crc.h between commit 3356c99ea392 ("bfin_crc: Move
architecture independant crc header file out of the blackfin folder")
from Linus' tree and commit 52e6e543f2d8 ("crypto: bfin_crc - access crc
registers by readl and writel functions") from the crypto tree.

I fixed it up (I kept the file under its new name) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Apr_2014_12_57_39_+1000_DrbgTQ6J4DWrCCx7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTT0MnAAoJEMDTa8Ir7ZwVw5IP/0u+s2ZQV10RGKoj0AxUep65
Ux3PbUo7unWkkwBiYSg7wK44WWxXrfsPykZsaODmw68R6srVwwsp0jLX5GZzgIdG
3TSLBlO6YvKPPFpdicRTQWa64aaRpqgyLAp0kRje9G3Mnqj/Y7mdAWsrq9R9s1uD
GoaaKKHA+4I8BAr2TKCM2DXHhlJ+4Ayce4QJ4W/Wi1oc5TM9VL0YhHn81RTWdUtR
MTmyeu1V2lqWB9iVQOxTyminlZOTz/KGoj4KxkxZsl9fO6Jqd6mDukplyJ305X6G
GzV9BLLAz6UM0BEh4/Ugt8aMbxSDAwE/q6ghrKgiFHwMzfEyM3yRkob+KhWzPBq+
bhfOaLejIiNOcd/QK9q4wZRIbLFsfNRIDXFmKfiXSPSJYnIUuZd4T0+YIVB5BsDX
Vs0vnYOQW8yvbxo2DDd5dAd0DlgEP3SvGIoKgZ+LWsyhy94o+/v8xH8RYBCPWHp6
hnsND85aD2IGVP3ba/XkxOjwYE5jww+vEhqXNE2CQs9VpDKxID4fN34T6XDqk+SD
exBwWdWzreFVo/M7XIHM8KUZ2RABtRzwDWtgPkcWVDlufjLsr13Eq8Ku0GnHdm3q
E3xONujpgCAs3kfWnBS5iXxVRIraQyuXTdzONwMW1+zsx0W4zO5Rs4kJ95H5TOGs
qu/i5B6MUfxkYF++7C3D
=zJXk
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_12_57_39_+1000_DrbgTQ6J4DWrCCx7--
