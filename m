Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaBTDBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:01:50 -0500
Received: from ozlabs.org ([203.10.76.45]:48168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaBTDBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:01:44 -0500
Date: Thu, 20 Feb 2014 14:01:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lars-Peter Clausen" <lars@metafoo.de>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20140220140140.9a4f1c90d27e77161116af8d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_14_01_40_+1100_HPVUxE9FnRKPVCh1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_14_01_40_+1100_HPVUxE9FnRKPVCh1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "snd_pcm_hw_constraint_mask64" [sound/soc/codecs/snd-soc-adau1977.ko=
] undefined!

Caused by commit 603597c9375b ("ASoC: Add ADAU1977 CODEC driver").

I have used the sound-asoc tree from next-20140219 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Feb_2014_14_01_40_+1100_HPVUxE9FnRKPVCh1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBXAUAAoJEMDTa8Ir7ZwV9AAQAJP57sZawXymiLvEg8FepD9I
/oTMY+Rs8XOug5cBmcfhHgIGLuUG8Nk9H0uG4V+HCr3YQwVpRl+Qt/uwnBOxKOgT
Udef0oi7DrAdRIVPoF8qb1Mlx4ZQ6Wsdplx1f7f3qTzd6jeQ0xbjDfgmwyF893Vj
LKIsND+HyXqCTSiW9KOYAZWsGp/y9LGlEy9zDbOgTAeNtuOcoWKI0VxvbV6xN1bM
2eMlQIDexR6xnePo01HJYQ6ALGDof9wcm+a5qyT8er05vFRTW75oSgu8Mvmtv104
pGpU/E2FcXOHUJAOFelWxaCLNi5gxjeqpeZ6xGQ0jlvmQCJ31nmAOkVoDvZrBelp
DPqKQA7cM6Mj9BoegDNkB8csK/J3RJFiKA+O5Mz64i28gaZ1MpTShyNUNeNMlmJD
ZDWowJJeLceCacggz5+vwYaiJG6lKmGJhnGusgMwomOHuG3j4aQtGrLwxo8b07Yx
zIRI7wwvdyzp/pjJSp7FgINanuP3Ha8v5N/QSlnFv5c9x5hsMmBOBvxashuCDUAe
8Piwbs6E7lJmH1PUV3/CbpoK8L364ACggPdxF36qAGU+MKBSfHbSdrfujRywPj0G
2djSNGZZxzxgUIa0JKb0rDwfYEBVlNBvHhSFlynQ6PnXwz+rIJfCdVylmyx9gtiL
Vi2WXY1/L4YtKR+vHOvi
=RYS5
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_14_01_40_+1100_HPVUxE9FnRKPVCh1--
