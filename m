Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3A1LXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:23:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54069 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab3A1LXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:23:25 -0500
Date: Mon, 28 Jan 2013 19:23:11 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the char-misc tree with the
 sound-asoc tree
Message-ID: <20130128112309.GA8301@opensource.wolfsonmicro.com>
References: <20130128215444.98524bf94e5fcd2035833055@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20130128215444.98524bf94e5fcd2035833055@canb.auug.org.au>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 28, 2013 at 09:54:44PM +1100, Stephen Rothwell wrote:

> Today's linux-next merge of the char-misc tree got a conflict in
> include/linux/mfd/arizona/pdata.h between commit c94aa30edac4 ("ASoC:
> arizona: Allow number of channels clocked to be restricted") from the
> sound-asoc tree and commit 92a49871b378 ("extcon: arizona: Support use of
> GPIO5 as an input to jack detection") from the char-misc tree.

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks.

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBl+XAAoJELSic+t+oim9nXwP/3QfIW5jHPA/gI8i2DVflUA1
1ETsF53Q2aN/eEhOJHM0jnR/uBtSb0s1O8/YpCsF1bzS3PCypeCwT62Bv/nx8uSi
MaIPyZ300ffjGSgzAF1fElHED751c1n5LPEJj0wAqdu9mKv7Y6TvITXomg5LXxKh
2qThTmzAIZ8SUR1w2tCkJREEQUcr8sUWq6fGUAPg0Q/vfAiGDsrjkvRX9eo5Pkvr
Cf+NqGkX66mcqxQxbBMV3aZ+l3wGux4RDGZazpvC6dK1gGlD6pHHLC6+NfPo8T6c
6RTVAhEHgfY1ueURwqVOOGVsy7Sz3czS06782PP/v7LDl8HwEbQ/ueqTDjSTCa1A
r9NowjI2wvmCP8WzEyfUPzQQIa8mLRFPAl8I6waguN0yReWNly5AZGkINLVH/GBw
tlqfiAqnmpI29f3PFTbMD1LPhgQQkfFIzOQS7kQJ5DQL167UPd+d6jgVOieS6sP6
cGcT5U1e1C2sS5GPwPjvUzzFnEkVvUptfM40nw2Z2wb5zmSsKtNz1cB6j4duO5ka
DShtCwyld/4H2WniADbt6HEgfAg9jbj2QMF2WWM6Zs5aKMkRt78NZGQPbtC2bmMx
9gxP2BO5wLGPwifBFV7ySR6O7j18X1LJVqtH9MHNylyS2WVnAfiDW2wwAFjJPvbb
/qPzuQFLO3oLCMQoSU+D
=10QC
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
