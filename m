Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaAEXmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:42:47 -0500
Received: from ozlabs.org ([203.10.76.45]:39131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAEXmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:42:46 -0500
Date: Mon, 6 Jan 2014 10:42:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20140106104227.6cbe4b16e2fe4120a7e1c51a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_10_42_27_+1100_R8U9A1sr.g.Q9gpd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_10_42_27_+1100_R8U9A1sr.g.Q9gpd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/boot/dts/imx51-apf51.dts between commit 8f568b496dd9 ("ARM: imx:
Explicitly pass the active level of the PHY reset") from the arm-soc tree
and commit 756c8d5762c2 ("ARM: dts: i.MX51 boards: Switch to use standard
GPIO flags definitions") from the imx-mxs tree.

I fixed it up (again, I arbitrarily chose to go with the latter) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__6_Jan_2014_10_42_27_+1100_R8U9A1sr.g.Q9gpd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSye3nAAoJEMDTa8Ir7ZwVWrIP/2mZMnlGc87oUOPiEVz8eCsM
AkCC0wVId0+J+EebWJoD2OYnC2BTu+IfCuSNY2wDI9flvqKTMzzV5w8Mp7imq0BX
jiFbYVNtfgipSvZtkogc758mIeh+pnJ7ZD6vWAXwFLFZLkTgCrIwtBtSu7MulCnK
rg17kSKZjJiUUGesUdgT3ToDYHOMwg0Yq0c6hQaoeplaRlfAyqGJv0ZcLya19CKz
GTBvkUPfRv+PCsY7/sDOlYwrzCj4DSVtXCSlODMa7NCd5JYp1tFcL27Oypx2YEEX
0fg9txHc5ZlZNZg0bKHd7UIH7Xnj4bvW0B8cS/Wj/NoVAtTPCCXoGPLcjbGy07ZW
CUBSsp4JQVgOZzjyqZllj3jDv9ULTx9oWa/7yaGulTYbRLakyDRPBo9CXjNmX+H+
mFFtZXSPbulTJjQZh/NGQU0EnK/qzmXlYFdo3LalStDy7ss7sNGDQB4MgQ8m682O
iqDia5lQr2hadQZEkOdJp2JVil/aHWW/N8YuCJKuuS8yN2DMkO1xNN9PRrNygFpi
IXXnOjpbaeUaKOI1h41R/BeoQuwny/FMmGHnvtM1mVcWgX5BopaHhpZbxK/gdoqj
heuNXCNysmLUhorQ7qEwlH2Mb2ZjbvALcz+P1IADrXjO2eAJigicqrAqiGLiXu8x
Ep3bYFaJ+hLrDbMu5xnl
=sxYX
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_10_42_27_+1100_R8U9A1sr.g.Q9gpd--
