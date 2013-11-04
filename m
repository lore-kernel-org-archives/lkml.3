Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3KDE1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 23:27:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33763 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3KDE1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 23:27:49 -0500
Date: Mon, 4 Nov 2013 15:27:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rostislav Lisovy <lisovy@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>
Subject: linux-next: manual merge of the dt-rh tree with the imx-mxs tree
Message-Id: <20131104152739.92ae486e7d418221c6a48a1e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_15_27_39_+1100_TfUPVhByj_trYU6_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Nov_2013_15_27_39_+1100_TfUPVhByj_trYU6_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

Today's linux-next merge of the dt-rh tree got a conflict in
Documentation/devicetree/bindings/vendor-prefixes.txt between commit
064d7f6c985a ("ARM: dts: Add vendor prefix for Voipac Technologies
s.r.o") from the imx-mxs tree and commit d6c3073e7fb5 ("DT: sort
vendor-prefixes.txt") from the dt-rh tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/vendor-prefixes.txt
index 8319844fb68d,640e86dc0ae7..000000000000
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@@ -65,13 -66,12 +67,13 @@@ snps 	Synopsys, Inc
  st	STMicroelectronics
  ste	ST-Ericsson
  stericsson	ST-Ericsson
- toumaz	Toumaz
  ti	Texas Instruments
  toshiba	Toshiba Corporation
+ toumaz	Toumaz
  v3	V3 Semiconductor
  via	VIA Technologies, Inc.
 +voipac	Voipac Technologies s.r.o.
+ winbond Winbond Electronics corp.
  wlf	Wolfson Microelectronics
  wm	Wondermedia Technologies, Inc.
- winbond Winbond Electronics corp.
  xlnx	Xilinx

--Signature=_Mon__4_Nov_2013_15_27_39_+1100_TfUPVhByj_trYU6_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdyI/AAoJEMDTa8Ir7ZwVvFoP/jHzUFShfhpRkm7bIP+yD5ce
XzpRJcanNAe4qsRwMU6yrBDcKWoxgRnvYlCv9ZbVzJ6oPGcycXL1q94eVM0VlAHu
l97Phdeyk0biawmQR2HzHLakV4Wk99yG1ci2h56rZscfa4iSEfdiV+gWmgpz4SmA
S5fWcrEdXSWcXoHrAAJeSohNYUk2eELMjP4iy/+4LRQPhoosQ4FRSiBUFxqNE6RX
c1sunqgWg23yjlYwwjQm1fGDzBWgtm9UgX73IXdSp/xGxfwwPTC+znL0bfd/koho
Jn1PhnbermhP/SpJHWt5uY86H8HGESjf29hDIOiCl0LrGJS2/LGYbc88DfnmelqH
P8zTmFs3PokaFq5COwCP7aI1RRgdaCwxrRxrfGjWTN9qSQUAxjv44MVC/0KACi5r
8mfmT3KUPPGPZVr70KrfrTWI6tYzgHtQVidIXy5PPu8dPTRHK6j+FqjhEbyzLA28
zFRY4TdchkdlyNVH3y5cRD78PlsXdpSQjucuYbCi1CoEvczmT05BdjFqHzGMKG1B
2kDUxdJro9EXC8lMZw/4gI0GdQ6v72ao8YEE6jCrM2fcsHAtBccOBHEPb35RORba
vEVAAno2xZi2a09IOwudCfVWkIoykU+oN5MIc7zDFLi8DtUFJfIi85JXOjAF62PJ
flkDsr9Q51jdAgfPZnLo
=fLpF
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_15_27_39_+1100_TfUPVhByj_trYU6_--
