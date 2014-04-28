Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaD1FVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:21:23 -0400
Received: from ozlabs.org ([103.22.144.67]:60194 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbaD1FUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:20:51 -0400
Date: Mon, 28 Apr 2014 15:20:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: manual merge of the usb-gadget tree with the usb tree
Message-Id: <20140428152044.5b5dd87a9e3d885129bb2485@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Apr_2014_15_20_44_+1000_jNupv9ytjWobH=6q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Apr_2014_15_20_44_+1000_jNupv9ytjWobH=6q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/phy/phy-mv-u3d-usb.c between commit 543cab640279 ("usb: phy:
mv_u3d: Remove usb phy driver for mv_u3d") from the usb tree and commit
041832565e40 ("usb: phy: mv-u3d: switch over to writel/readl") from the
usb-gadget tree.

I fixed it up (the former removes the file, so I did that) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Apr_2014_15_20_44_+1000_jNupv9ytjWobH=6q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXeUwAAoJEMDTa8Ir7ZwVA3AQAInCV0eQm730HjBo0S97wOcw
HUjHf2M6Eg1sQt0Bc24nal/Ew48AyF/FlgDL5uvpRiZu+EzqSCA6VOuRkMfj9jxW
dt8F9x4LdZZO4WCAvRsrV50pQtJ1WuPRbs6mL5EnC5bvUGEqgFUEai5LbtSxNNC4
jpUdopTNmx/pMCrqn/bYRKOVf0rC6DNszazfXgmj7RVYbfzIMDsWAIyfDllFlOpc
QwfJ/Y8V1DekiQGx2MeydrbK3FBiw1nPpvP3rIZOBegF9u/0fGRSKeUxt+pDS+UV
gCUQBjz5omvOY1xG6MdefZ0tXOI5jWWvROx5H9yAjzbsP+YKWCaqiGdaRzvrsf8b
F1Y63K+/hZtDOQvNvKd9RWw5ExJCN9cwhrWeTvZ++d1vbCp7mNum+H86rSyzssAq
GE6AdIDecnDoFsz1XBmSTyLo1+LJsQpNImuWD/V98FlAnpiOxBVvwggTIZJ0dqBI
gMNgtrFHU/gHiTJUQEbiD3pO/Gpv596orSLksrN1/VpLfeUesvf+v1PWHMcyZ9Uf
j541XBn+k1N94ifYu/LtOSF5O9Prmq4uziMBJjW9iGxTCpYxW81mK7/bv4vMD4pn
wP8teeUTy+M++gd6+KfpRMMHybJ6qZ4F2EroBdoiH7WVDMmiR0IoA7N4RlFmzxfu
Y1HvhynyoKPytkcuptlv
=PAEV
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Apr_2014_15_20_44_+1000_jNupv9ytjWobH=6q--
