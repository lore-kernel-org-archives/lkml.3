Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaEOGLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:11:30 -0400
Received: from ozlabs.org ([103.22.144.67]:45005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaEOGL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:11:28 -0400
Date: Thu, 15 May 2014 16:11:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>, Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: linux-next: manual merge of the clk tree with the renesas tree
Message-ID: <20140515161121.39998223@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/DIBg/d8/SGKnLDEcMnbpxYX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DIBg/d8/SGKnLDEcMnbpxYX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
between commit b557deadc5cc ("ARM: shmobile: r7s72100: document MSTP
clock support") from the renesas tree and commit 5483bf698f42 ("clk:
shmobile: r8a7779: Add MSTP clock support") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.t=
xt
index b5fc72621bfd,30df825d72ef..000000000000
--- a/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
+++ b/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
@@@ -10,7 -10,7 +10,8 @@@ index in the group, from 0 to 31
  Required Properties:
 =20
    - compatible: Must be one of the following
 +    - "renesas,r7s72100-mstp-clocks" for R7S72100 (RZ) MSTP gate clocks
+     - "renesas,r8a7779-mstp-clocks" for R8A7779 (R-Car H1) MSTP gate cloc=
ks
      - "renesas,r8a7790-mstp-clocks" for R8A7790 (R-Car H2) MSTP gate cloc=
ks
      - "renesas,r8a7791-mstp-clocks" for R8A7791 (R-Car M2) MSTP gate cloc=
ks
      - "renesas,cpg-mstp-clock" for generic MSTP gate clocks

--Sig_/DIBg/d8/SGKnLDEcMnbpxYX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdFqNAAoJEMDTa8Ir7ZwVqtIP/3430H+vGs0teN8LtJkLBoe4
ZPYcAEsVly4CZGjU0ZB13KAymKTw6I+uTP2dh569m/oqTw8yodjvtJ20pDSoDCW/
wqKn5UYUwdhHgogPJ9cpTeydGkDGSKt+mudMCPRbZLm6SZ/TPSs0/fljcMGSHY6Z
SjQionBFZv27KdicJxD7VWPm9s39+pQNgRafROPjCmeRbRvKei7CrM6Y+LvWMBBk
onG+PsjuT4zXHnvnGPepAcgKq7ffpaULPKpqNpIPCl96ikdrGl4Bi18iqN1rwCLp
P/dgYr9mCxXBTrkkYkIhlZYhvBv4z82y0/BbeJv60jFkCjEcSdfD1ICY8PmTGsrE
K9M3Kf2/RumLOntx4mCCwTtea+CJu8tLXhsHYkuJNrf0BDCkmZOqdJTFSWV5MMXT
/0+jmttUHcx/8/WAX0Cc4hjkWtQF22SkU/ciUIuH/xxNn2E0Mx9HdQXaned1WG/J
N4VTBCIFvP3kIx/EGkHL4L5dFqCtQBR9pwAVlb1SzSIUJrDQBn4vGwKWD9Xd6rdf
cCBrvo2ogiVd5A9+6fKGZjWvrPN7OKsqEZ7QwjxBpLKU1sOQmh7ERhKQQX4omvQf
WRqJvjhABXTTHCflkdlL7HPF5xdnf39lhiM7WwLdE/eAn7jkNgIY0XMPjpWNWm/l
t8sWfs+Rii2l63ZnNKNZ
=g7sI
-----END PGP SIGNATURE-----

--Sig_/DIBg/d8/SGKnLDEcMnbpxYX--
