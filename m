Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaCRAVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:21:47 -0400
Received: from ozlabs.org ([203.10.76.45]:57970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaCRAVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:21:45 -0400
Date: Tue, 18 Mar 2014 11:21:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann s <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-Id: <20140318112138.75a24ca8a0719d5b3fb98720@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_11_21_38_+1100_pcZ9NIDEJ8LVe.Y1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_11_21_38_+1100_pcZ9NIDEJ8LVe.Y1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/boot/dts/Makefile between commit 8fc1b0f87d9f ("ARM: qcom: Split
Qualcomm support into legacy and multiplatform") from the arm-soc tree
and commits 97623e934388 ("Merge branch 'mvebu/dt' into for-next") and
54cab10f63f2 ("Merge branch 'mvebu/soc3' into next/dt") from the mvebu
tree.

I fixed it up (which produced no git diff) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Mar_2014_11_21_38_+1100_pcZ9NIDEJ8LVe.Y1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ5GWAAoJEMDTa8Ir7ZwVepAP/jOeP6HWmmVFMWmwWXgRszwX
N7JEG+YlDxWx/wbZfBYf9zagAMlbAURoHk+3UsnAq4ioQKAlhlcDVjib3FYGtGiE
egSXEhoqOyVL3cwAdodc9VvSTOtcn/QHfpMPFhTlo/L2RYtJzS8dDG39Rah5QO6N
Rno7Fl/s3CRqTNriVILycZXZffi/VqCsssoRXQVtM9TyC1mixbSFCHSlkCaKfkph
wDwFHeKuKWCgm4JEydiJjciwFDt6+llxd8FBXZ+u9+GpRglVFzRrEe4Znjqnf6VY
zEPyj52PAYUCtTcEi/l/YucQwSLpYRY2Ub/BNNWUEj3nqieJRR4hqYTtlDW4Gyn5
FuUPxcZaROvJvnzz32lPbRoXL5wvpQFela1ymvHCIkqU6+sLEGNPThBxyDwo+bC6
Dvu+4sIXDb594+FCwd0+NrS1tw3HBM+fSJ5TS4XWBtyCZGW7O1/10VHedNAelgum
tL2lWjK267dlC9FXWBnW2LmAFFymoadTI79K8R96XemicdqBd72SUJrr1JJtE3Mx
CtRyBksyuxpq4N63Ve5V9f8KFR85edrYpkQgddugIumklO9MAD+Xaf+3AXhvXemA
QRNQ2XLRkLUnRjoqoaFcyUL2H4cAzm7bgzIfcQIsuLjtwfzg3Zh9WXRfCPJ+1Uor
GyhDAxkyxPGh7IF5gZF0
=/fR/
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_11_21_38_+1100_pcZ9NIDEJ8LVe.Y1--
