Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbaGDTbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:31:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47318 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaGDTa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:30:59 -0400
Date: Fri, 4 Jul 2014 20:30:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz, lgirdwood@gmail.com, trblinux@gmail.com
Message-ID: <20140704193044.GH14896@sirena.org.uk>
References: <1404465137-14295-1-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Content-Disposition: inline
In-Reply-To: <1404465137-14295-1-git-send-email-tushar.b@samsung.com>
X-Cookie: This bag is recyclable.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add check for CODEC type
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 02:42:16PM +0530, Tushar Behera wrote:
> CODEC type (MAX98090/MAX98091) can be specified from device-tree file,
> it can also be obtained from the CODEC during runtime.

Applied both, thanks.

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtwDgAAoJELSic+t+oim98GYP/jM79yDXSwhxuY4ljCiQcwVg
kp3Vjqqf7by891xrRyKnoFZHKyBVeTa3gdqtNtm9Luke+r9Y9o++ibWSEPNfVccr
hUyRNXVNr6bvpZqZXV7mdTYGJqK+fif8/q/5huFlCRAuzJNM22JIw7d1LZ9Gok/c
Hd7UvEWXHEpJIP7R3rIukOK/qdsVAc++Q1fAW1kJpQvCB5NT9njjoXvqfkTcNCFc
pk/C+S/19Cpc3RRmdE10104g5HBfgEdktrsflSU6PG9RKsrsfrEuy7FG6K8wbWos
AdsFHLoh5SmBkDsHOJkpx2KClbw2EiBw4dWJ1htRECkSTH0Om6jcBOdW9cMh/PpM
q+wC1RUbPZqk3lBELGQp9mu/Zp1KFshUBI2BZwNEVsg75SvHHW3vKZB/v/3rDPFZ
7uA+gRysAyiYqdNBxBRaG9QbAyCxbNvb0lqjwDPNXIZY/R2qyye0rG6SYXZR8SnP
jg+3kGUKPuCa88wYWfxP5MSBw0KgLBetjk+XAQGQVeT6fMUReoT3zeK4fIU+gG9J
5OhejM4RzuG19EOw0PLVpJu6sj/BUwdupZp+JlGQs33DLnaHjAHHjxww5UWVlauZ
NMrPOlVTlGFrPWtnRGN9B3/ICKXlpWaeWuPRA7goI+pfD0I5W1pEYob5l4wqgpOq
+BeApryJzq4Bxt/Wpb3r
=8WWo
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
