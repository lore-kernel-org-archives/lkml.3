Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaG2FxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:53:14 -0400
Received: from ozlabs.org ([103.22.144.67]:55896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaG2FxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:53:12 -0400
Date: Tue, 29 Jul 2014 15:53:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>, Matt Porter <mporter@linaro.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: linux-next: manual merge of the irqchip tree with the arm-soc tree
Message-ID: <20140729155302.3c1d5437@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/cDZdTduRx+6i1wcFhpCSIY4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cDZdTduRx+6i1wcFhpCSIY4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the irqchip tree got a conflict in
Documentation/devicetree/bindings/arm/gic.txt between commit
f80b71397d09 ("ARM: brcmstb: gic: add compatible string for Broadcom
Brahma15") from the arm-soc tree and commit 3e44358c12cc ("") from the
irqchip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/arm/gic.txt
index c7d2fa156678,d2eea0b75580..000000000000
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@@ -16,8 -17,9 +17,10 @@@ Main node required properties
  	"arm,cortex-a9-gic"
  	"arm,cortex-a7-gic"
  	"arm,arm11mp-gic"
 +	"brcm,brahma-b15-gic"
+=20
  - interrupt-controller : Identifies the node as an interrupt controller
+=20
  - #interrupt-cells : Specifies the number of cells needed to encode an
    interrupt source.  The type shall be a <u32> and the value shall be 3.
 =20

--Sig_/cDZdTduRx+6i1wcFhpCSIY4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1zbEAAoJEMDTa8Ir7ZwVMGoP/jfHRcNayCMivuExNfloBclK
f6pgGRBpG1A/RzqReIohGdeidoeb/VxUF88mlqd+g0gKCjRZssUlL65XiVJQWCbB
vFP4cl1bNYdSQpk0UbYChRb6TYeyPgE1bqeUY9I7MQL+HJcen+MQDNE5SMDigMqI
7Lew4BX71/5XUErtwrxFsYqLrmw7hW828pl4M1by3b6uW2+v62vBe9fwVIKjgggS
yQN6HsPTEywplZAWyfWx13rvmfbpzpq9QeOTyj3Dxgf3aMIV0pbf2OA5Wg2ZbVo0
OAxPStXDUxTCXbN9Apq+cyqbdywNPEUOiFpTIH22IGLjpa6QmpTiCvHkaFzV6c00
BeCmGNmyyb4KPxd3oBuirMNXx0OduFLUHvB9QaDGQuzCEnRkrkzD+8IgJdjSMFIy
1/cSDIGny5+U4tXs0NkGdZQkXJveE7cnbZ+EKxxZ8ThMnQpaHgVzFOvUrtLqaqbY
yjtD0YNlbggOCKZULt6tnwGvU6OMvlAynUQ7pH3niDZ6E6Kc2CHUQjcDPdmhdpVm
DF73id9+nn+oL+xVIetxEOhhjenJg+cjBhxz09xWN4GZeGQkCNkMuEjwdjQHBlGx
FFBwZ2AqiosNAUJ3gGrclKSnVnAyDF9/5DbFnRRueAGUaeMPG5wubWTK5Dfqe35T
ks8xIbzpYMLw/6NXQW/I
=YJYM
-----END PGP SIGNATURE-----

--Sig_/cDZdTduRx+6i1wcFhpCSIY4--
