Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3A3B53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:57:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39936 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157Ab3A3B51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:57:27 -0500
Date: Wed, 30 Jan 2013 09:57:18 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [GIT PULL][FOR REVIEW] Regulators: Bring the AB8500 into the
 20th century
Message-ID: <20130130015715.GA4945@opensource.wolfsonmicro.com>
References: <20130129164131.GN18212@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20130129164131.GN18212@gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 29, 2013 at 04:41:31PM +0000, Lee Jones wrote:

> If you'd like me to sent the patches to the MLs for a better review
> platform I can do, but I'd like to get permission before I go and
> start upsetting people.

Yes.

>  drivers/regulator/Makefile                         |    2 +
>  drivers/regulator/ab8500-debug.c                   | 2154
>  +++++++++++++++

Just looking at the diffstat if you're adding custom diagnostic code
that's almost as big as the active code itself there's something gone
seriously wrong.

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCH31AAoJELSic+t+oim9SjwQAI7ed/onoXoznhyKPtj2E7Va
4RFXZDw0yv+ySLc+d2tXDO8jgByFTrsm48W/aXCSSKcg92U/BBQxdp5T8ds4O5z/
5bGPJDBvH2aB0IUmQqK9N7i4l01zklFiLSEbO6Fd+U+LNp33oIy3Vr1ov6Eqxgn4
E0cJSsuov/vkTi5jKB1z7b0sBgDrCHaNa5m5dXbxfykf/f083gQa+q5l249n9ojY
XnCLtD78noetoB82FnF2afy0gM6jWFHUGgjKuwXS1nuA0gKlcRtsDLBFCzH71RMC
Di0c5bwUG2JeUANpleYYdxn4BUGXgtGncMr7HbkqeLWWhTawAnfhAbq5zVQc/J3h
iu3CWdvnrNZFUzMxrY9Sj26wtS7vDxdseruo8egfkoeVg2mj65n2tObM5igDMf+f
Iki8/CqUg3D+U1eZX18G5HpC4jNc9PwZ3lCT/kmaGVHQnHqi0CEINMIIiIb8eT3e
GEffv0RTbtiplqYOj/0MOCHUhtVNgX8dw4vGcNO9vNOPzUsHjaqW/I35VSDmR7/B
wj2voowPRrnlOQUdYI1ZnpRgF4DngKJQfpcltS8m2RSMyL2Dz2BPBnyMn+epuxhT
V3HSld9EVHJ/bZlrf4t1i3cC3ZpuDftQ07J5sDwnGTLedQSyxsCptI7tHEZ9IsMZ
PsKM0sflNNJpjFlJ07bC
=wim8
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
