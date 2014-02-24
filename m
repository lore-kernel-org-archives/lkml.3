Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaBXAsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:48:18 -0500
Received: from ozlabs.org ([203.10.76.45]:54817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaBXAsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:48:16 -0500
Date: Mon, 24 Feb 2014 11:48:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the mvebu tree with Linus' tree
Message-Id: <20140224114810.468d0db355553fc15629592d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_11_48_10_+1100_CIfG1biWB6lSi8.7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_11_48_10_+1100_CIfG1biWB6lSi8.7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
Documentation/devicetree/bindings/vendor-prefixes.txt between commit
d5f93b8ad01e ("of: Update qcom vendor prefix description") from Linus'
tree and commit f7f2ea9f49b0 ("DT: Vendor prefixes: Add ricoh, qnap, sii
and synology") from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc Documentation/devicetree/bindings/vendor-prefixes.txt
index e9d19e2b359b,c73b435f58f5..000000000000
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@@ -69,7 -64,8 +69,8 @@@ phytec	PHYTEC Messtechnik Gmb
  picochip	Picochip Ltd
  powervr	PowerVR (deprecated, use img)
  qca	Qualcomm Atheros, Inc.
 -qcom	Qualcomm, Inc.
 +qcom	Qualcomm Technologies, Inc
+ qnap	QNAP Systems, Inc.
  ralink	Mediatek/Ralink Technology Corp.
  ramtron	Ramtron International
  realtek Realtek Semiconductor Corp.
@@@ -81,9 -78,9 +83,10 @@@ schindler	Schindle
  sil	Silicon Image
  silabs	Silicon Laboratories
  simtek
+ sii	Seiko Instruments, Inc.
  sirf	SiRF Technology, Inc.
  snps 	Synopsys, Inc.
 +spansion	Spansion Inc.
  st	STMicroelectronics
  ste	ST-Ericsson
  stericsson	ST-Ericsson

--Signature=_Mon__24_Feb_2014_11_48_10_+1100_CIfG1biWB6lSi8.7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCpbOAAoJEMDTa8Ir7ZwVvasP/2m2mZel48QzZNbn6BKW2UeE
zulPy5mCHHAqkOdSkWkN+6S6mjiJDSWpz/HZm81ibyz9Vl09bXBQqkSSjDskfZaW
ZO0q6otd7JfNz810uAyScv8dkW2e1WV0N4ZAnxtdcsxhnsRqC5IjYHYng8fGovfK
Jo8+mXAKCrpxzjpqoU0b/wka56rw8EX2dKUayoFdbPMfYqCtoqr6aYNEOHn8R7XB
K16xvFrXr5p+Mv41AL0YKTerti8kqTmvyXy64BXqjb+vXZ7A1BK9ii8E4hk1Ijk8
n1SwGlechbABDEd4jp0vbk40zSQSOUV4db6sgWLXEaz4rO7UcEwvYwDlHr6VVnKP
p1KAE95iTYippjspqHkm6eqN8CJvq0EqVqahvHwkWZ0sajvHwl1g5GC/GEw3a7mQ
Qp/OIKnCEu410djPQojjkeBQlrmk9hABPCRhOofgD35ePclljUEQJDd/3rG38eeg
tysZVvjK/6P6KCDMTEJDCMVwS4LXGNVYr8Q5iqy6TD0FBQ+BFsG/rKWV4hZD4RLM
KVsXSOOlvYN0CuKGvxJfo1urxJQWavNglFLYwyndlkD3Kdo2oiEgO95UToWWrdAl
4Rfq+Vwsj6NFeCaLFA0Bi6Rjh1gtO8wqmPL8wOq6nHhZstMpPrAIAoENY7Hpl0ma
zRw9yfl6huFUKTw0Bs7j
=pchW
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_11_48_10_+1100_CIfG1biWB6lSi8.7--
