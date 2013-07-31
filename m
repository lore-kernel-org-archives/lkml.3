Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab3GaNon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:44:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60199 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763Ab3GaNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:47 -0400
Date: Wed, 31 Jul 2013 14:25:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130731132522.GP9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCmrFqZYZ3TEjivu"
Content-Disposition: inline
In-Reply-To: <20130731131627.GA32631@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: init delayed_work for codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCmrFqZYZ3TEjivu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 02:16:44PM +0100, Richard Fitzgerald wrote:

> Pointing it to a dummy work callback is cleaner than taking
> special cases in the code to bypass the flush_delayed_work_sync().

Why is this better than pointing at the normal work that you'd expect to
be used there?

--zCmrFqZYZ3TEjivu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+RA/AAoJELSic+t+oim9lwwQAJM7l2LppIEkQiAFMZwzq+Wp
zyKBucwlPeHoJcga6OFWpkctS2dBVtrgU+GTxw2uZp9kAzHJSPgV8YriJP6ckbVh
tAh692dWPZpdTOCHzCS0zjnf6jp/BCw/NKwSH+X/9CzSUqCtMYxkTQFxF2BDpQRT
tDqxeuoujQ48mAT5cJCFgaUb/cP9UIuJ9IYMlUtOpe1VS8ByXb6K0Jo2HODuIirp
KnCxmowH+09BH6K1any/+zoYLAoSHCLWosllO5Jv1UGD2GcOV9EIGGcok64ICklB
wv7Jl+YLJ7iVsJnfCSvvsnA9+hikmhv69zvxTm0CWrhWDQdjbhoDOUEj/AxKMVMq
9WoiiVam+QntiOcXg+M+WvtHxOz9u5RTWm7xUMfHrNYmk+cAdFQZ2mXiZ9iJ71Kr
cCGVwXjGxl4nEI8hTa80kj4ar2Gtz0YCNveBiG4s8hwXE+Sq4KtT+U4yquwSwHNU
0h1w2RP5IxnK108ZBGl42I2JkNV+0mcmRfFoQfSYB+sF+mZ6X03RUQjO0E6j41b7
9Bykx8sdmcpbwFyoHLeJ5liBexvcFmsrhmBFPSRfDeJCIlorWmRDSf45AicZbMRO
OHJrSxZcsEwxjYh9cs4KN4pfZkI06eGFN9/7o/upyYdxiS/G5rgmceeLkjxcbQ3f
gIoXG7261MccVecfTgrs
=CIQD
-----END PGP SIGNATURE-----

--zCmrFqZYZ3TEjivu--
