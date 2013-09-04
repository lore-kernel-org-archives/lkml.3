Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577Ab3IDXqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:46:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44038 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762229Ab3IDXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:46:31 -0400
Message-ID: <1378338372.27597.4.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] hwrng: via-rng: Mark device ID table as __maybe_unused
From: Ben Hutchings <ben@decadent.org.uk>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 05 Sep 2013 00:46:12 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DqBJjElFX0VTM/GI1UF2"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DqBJjElFX0VTM/GI1UF2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It is only used in modular builds.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/hw_random/via-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-=
rng.c
index e737772..de5a6dc 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -221,7 +221,7 @@ static void __exit mod_exit(void)
 module_init(mod_init);
 module_exit(mod_exit);
=20
-static struct x86_cpu_id via_rng_cpu_id[] =3D {
+static struct x86_cpu_id __maybe_unused via_rng_cpu_id[] =3D {
 	X86_FEATURE_MATCH(X86_FEATURE_XSTORE),
 	{}
 };


--=-DqBJjElFX0VTM/GI1UF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUifGROe/yOyVhhEJAQrI3g/+OzB546Q+Se7Vm2B9QUJJF9cfAQmK762n
YwHtwVko+ICw76Hk+bMIoLKRf8K4S8RQPE80r/ZBguKiQF7K6mmq9h71Z8cQL1/f
S01F0edqoLKRyyNir5F8oCMwKRSY4ZgX+4HiToE53XnI03JyMKXj2or48zRq4I7g
xqQBzjC6kiJ9+LV4okTkAOFXfRmRvY3oB8hkG4jI7e6RnJo7aJS69wuuJ/ucMUfa
bxEZlUPFYNXTOravjW0ODURRgM1Csq4vZPCklk6cM1oOpkr/iMjYTmjmZXCbbVtp
02m0Vld0ouBLrhG8jvkvcoJc80QgTD4ClduKETiX1luC7xBBK/szR+lOCysXcBAk
iyVaNWIcq4B8fBPreFtL2++E3gyS0AKwXsayWHPhYL30bQ/A0QVc1mLpXeFXD0Xt
aEzvFEKRM1+8MC3HonQGyp/sTe2VoLhuQr6NmjLM4wzdrhpZIcNAiUqHz8XzyemT
Zj3fMo2jg3yjF3GPULGEBWIcyW8jL9a0fdS+lFd8yvXe4diT6XhkKTV6L58LOaEK
awQr8QgWSEoMjncNJEZZ/y5dGmMEd7uzWzydd5perG72effWjg5PE4oH+WeJ28hr
Vlfv4MUL7nkx15DDMnRLVAUfsiO8pGEcxqDHgbYAhR4hDK03ej/l+wj8HlP8P5NT
P8/pYFCv11c=
=ACIC
-----END PGP SIGNATURE-----

--=-DqBJjElFX0VTM/GI1UF2--
