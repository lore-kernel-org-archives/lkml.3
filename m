Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaEOHDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:03:18 -0400
Received: from ozlabs.org ([103.22.144.67]:59233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbaEOHDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:03:17 -0400
Date: Thu, 15 May 2014 17:03:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Cc: Amos Kong <akong@redhat.com>
Subject: [PATCH 3/2] virtio-rng: reinstate const to struct hwrng.name
Message-ID: <20140515170302.087bd3e7@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BnahQ1QF30Tvrr5bTD1GDHJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BnahQ1QF30Tvrr5bTD1GDHJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This was removed by commit 08e53fbdb85c ("virtio-rng: support multiple
virtio-rng devices") in the virtio tree and can now be restored.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/hw_random.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 02d9c87be54c..b4b0eef5fddf 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -31,7 +31,7 @@
  * @priv:		Private data, for use by the RNG driver.
  */
 struct hwrng {
-	char *name;
+	const char *name;
 	int (*init)(struct hwrng *rng);
 	void (*cleanup)(struct hwrng *rng);
 	int (*data_present)(struct hwrng *rng, int wait);
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/BnahQ1QF30Tvrr5bTD1GDHJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdGarAAoJEMDTa8Ir7ZwVd6IP/0smoJMPX3tFLZ1y9A/FScnv
VtAILb0rVF8Iq01+TuveiDHBJveE3D7DTEQFBscsz+J319mzWK71nnYNYKLyQ3Ir
Nv350EF1eu2VJKiJpEk3/MeVQLdfqmROcyDkBH7RnoSoLCZaQtTLkjxlxonwQqAL
bISW/+o/vOkT5W1oln1YJ8D56dvBmXc8avIkFkzu18/6i80wJtdkRy489YwF/5mX
1+UwZIfwnUQoWrVJ9CDWfGg4lanycbPJXGtap0CMaHOH6/ETYTFXPWi7/sCPfca5
vbQbl4lXYKWE/GA48XftOv2aTM8VFnJ2miapm1FVu6o2w0uHawGYGrUOgJb1XNo8
qIYgAWpdtiz2+l3X7qmBjg2AdYMdvYHRcGjzWXkroJ81TAkf4xeKp9yIVQW4Iclk
7Y3azlT57wp4GL8JKNvgokslM2AgU8I/TB6bldHOe5pkFrxBMl7WpxtvyOHAw1Ld
fACSAaGDa2WKmcXlGMu/8xsaBbxUMEqzBwaVqKIEUI4i3AwkNI3ALKFrG/9XwUEN
+/kSGngdwraXBeERjRghN8l7TmVQmJElGy2YPLlkfGAZCdt0bgopAFVV7UQjjWlo
7LorMtK4PUnwhIbG75iDEaLZat0BlDsc0IYrWm2yc8fFTYXt0jbJhP8f67BYLVFr
ao4BwWibsn9doz88FCgX
=PcQl
-----END PGP SIGNATURE-----

--Sig_/BnahQ1QF30Tvrr5bTD1GDHJ--
