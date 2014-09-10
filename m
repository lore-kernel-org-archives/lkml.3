Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaIJHdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:33:45 -0400
Received: from ozlabs.org ([103.22.144.67]:51025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaIJHdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:33:43 -0400
Date: Wed, 10 Sep 2014 17:33:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>, Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: linux-next: manual merge of the clk tree with the renesas tree
Message-ID: <20140910173335.594bf533@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/f/26H2T0/Lx5SdFyXpwI7vb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f/26H2T0/Lx5SdFyXpwI7vb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
between commit b32c44b93af3 ("clk: shmobile: Add r8a7740, sh73a0 SoCs
to MSTP bindings") from the renesas tree and commit 5acb7bbbab7c ("ARM:
shmobile: r8a7794: document MSTP clock support") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.t=
xt
index 8f1424f0fa43,a03c8c029a94..000000000000
--- a/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
+++ b/Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
@@@ -15,7 -14,7 +15,8 @@@ Required Properties
      - "renesas,r8a7779-mstp-clocks" for R8A7779 (R-Car H1) MSTP gate cloc=
ks
      - "renesas,r8a7790-mstp-clocks" for R8A7790 (R-Car H2) MSTP gate cloc=
ks
      - "renesas,r8a7791-mstp-clocks" for R8A7791 (R-Car M2) MSTP gate cloc=
ks
+     - "renesas,r8a7794-mstp-clocks" for R8A7794 (R-Car E2) MSTP gate cloc=
ks
 +    - "renesas,sh73a0-mstp-clocks" for SH73A0 (SH-MobileAG5) MSTP gate cl=
ocks
      - "renesas,cpg-mstp-clock" for generic MSTP gate clocks
    - reg: Base address and length of the I/O mapped registers used by the =
MSTP
      clocks. The first register is the clock control register and is manda=
tory.

--Sig_/f/26H2T0/Lx5SdFyXpwI7vb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD/7VAAoJEMDTa8Ir7ZwVugUP/07rvzIz4QrQ7Q7tOtczr1Ro
l8aoTVmYt+5vur20rZSnkBtVm5qy0r3DCIhtnMSrM6/+AGsu3nrLjICFLNVfSzNG
EOy17ZVGXjWPTFhXGNt6+/6gIBDnNGVsw9GjUhRVrpbymLbpEMr2e4zq2NNYJpRL
ojjRsWmA9PGqgo4GcAJGhtT+Fx4Umtk+I2HBqwOgfeIwnZ4zOKPzW03XeWJjKnlW
WujblPrLeOdKgT8P3SFVXN4Z1cowpy/tSQePFPOZgqCzOgvjkK4oHbk7e66wmW2P
bUushSTUl2FpnR+F+rUuJz+bI2wQqaa94xzttCPt3m2ly5tjYn+kdo+AyhbKWOaN
VGn+37Ik+N/8RihZ1+/wbic854Ot81rUQ53OshxsNAHFtjXQ3qFp+AtAYfstKgT9
oD5Cs4AsuN2wg+NCGh7rucvtgNVBbj+L2hTrbj43903R4rU8ilD2KDRXxs/yUZGN
yiCVhe7ufnbt79oY1PE8iJfYsC23htwo/sSwU/+xLhpopHbZ2rFQ1DJL3zgQD95B
oJY5Tj8W/B4TgmFjwsQBjW/vAyEGtbe1BEPLYAvtWLJigRJhCWwY+u9BCDKEmGHX
a3fnmZkaVXb/7agFnYx5XBw5DJlvGHCjpL/PeBAAbQsMCQuljpYgACnPUqh4PjE1
eHKvjI0pTkmAgfQfjZwN
=40jD
-----END PGP SIGNATURE-----

--Sig_/f/26H2T0/Lx5SdFyXpwI7vb--
