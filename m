Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaHQWbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 18:31:09 -0400
Received: from ozlabs.org ([103.22.144.67]:53398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaHQWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 18:31:07 -0400
Date: Mon, 18 Aug 2014 08:30:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Cross <xobs@kosagi.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20140818083055.7cedc567@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zlufTVKnGMd=PeaFMkF0Zo7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zlufTVKnGMd=PeaFMkF0Zo7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (powerpc allyes=
config)
failed like this:

sound/soc/fsl/imx-pcm-fiq.c:31:21: fatal error: asm/fiq.h: No such file or =
directory
 #include <asm/fiq.h>
                     ^

Caused by commit 7e7292dba215 ("ASoC: fsl: add imx-es8328 machine
driver").  Presumably it will only build on arm?

I reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/zlufTVKnGMd=PeaFMkF0Zo7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT8S0kAAoJEMDTa8Ir7ZwVgmYP/30c5f0HgF0DyEmixUb2hflt
90CJKU8x1Lwts750Xt7b5DCIy7qy8c52gItiik8JPE5OQOqqBNFMeSBNVUiDPw+V
8Rdtlufjckw3TwqiE40JqnIQPtT+7hxvmL/0c06zyUZvkn81JwDoTr3nYMH7luWx
5bIvPh4hR4X/6VAxa6xS8s8IVYPBVVtEOTDbvb1FtDRNVrV1p/mL9hADsQAk6xk2
HRshSAgV1ID+aAKAaSjGzEblAm2D+AY9EeBmmZbs/dqIr286fCit1BQYnMiW9UVO
O98LwbWcvJPR7oxdl6Ttamj5flzWONhGzPJIQMdBfnQpRp7HgB5w8mK8iwoO2RFb
arM92nzhMa6Yr+bsuWYCjsjJdscov+HismMT7SPHldG00zVqH6eDbcWNJCCESNwH
II16AvSxmOlXttnwpEpXkN2gI3RvQrgHXno0xGz27cbcbAsE6/il60ZEutUu2Fum
OT1brT+Eb0X3xyEG34Ssx5NDfkQ5qydgeJrw+cUupgOLvulvnShJ1C8rV2XoAGT5
3DLN4jZ/EztP3D/5WKzahInMnxYRGtZBzL82VhyAF8EjM1A4r1t2wsfrOtExR0jJ
oRHTYwq0L1KXMUTR1kAhhHj1edp/RA4Kn56C7/BE/6nLw/1kd1i611LCIOSRfUTY
vfmXxg8/EfcovcRTjzr7
=iZPv
-----END PGP SIGNATURE-----

--Sig_/zlufTVKnGMd=PeaFMkF0Zo7--
