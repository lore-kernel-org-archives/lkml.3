Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3A3Kpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:45:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754915Ab3A3Kp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:45:29 -0500
Date: Wed, 30 Jan 2013 18:45:14 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6507x: Fix using wrong dev argument for
 calling of_regulator_match
Message-ID: <20130130104512.GC6229@opensource.wolfsonmicro.com>
References: <1359291280.11083.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1359291280.11083.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 27, 2013 at 08:54:40PM +0800, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.

Applied, thanks.

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCPmoAAoJELSic+t+oim9kswP+gIdj4rD8f6KOyt7RaF/IM4U
tCou1CTKxL8rsH10+yD4DLuGeQky8iNy2Y4o1zOF6R898JAY9Z7HTa2WVcDnP7sc
ZNYabTGj5UmCvEwCJVFAGHZ1xQjeOBWVTG7wnIXtUqNSEVITQtY3J4RkEAjhgHAU
gKW5RBowdVg9OfKF9Yi2GlQN5gRUAGoMxSs/YUdoLYjg7fktjSCTY4JsEOWj0HB6
bVtH4cZZZHhZTiAMR+T2qxiHW9vOx5mSKjiUa+4k6Uq+nvcCbSGoa+83V0Z71Unt
AIaPrdRtOxrcl2sGNGx4/R/J8qhMb+cRM2DXcmmzLdyRbD1K7OEMyvCREXeDxS56
aPQHAH2kRLyinJMAvS0Tj+ebYpQ5rCjmNvq8yXluQfdJkvL3u5oqD3xK3Ohiu2si
VyFS6Y9lNkGG29hHVlk++6sRjRSKsQnCBFQt6ZHSyq/AM1Mq44bbrfcuSk4zgmXm
9FxUiOuKGi89207qx+cm1dZmIyEJYje/NeQGVQjkbq7waDtK9vnFhB3rgJjwTNSp
EQfplBQ7TZqydQjYw7ylPzYy2ztrVBj7ZV1xPh+/Nck311ssdsA3RwG/DDDok+4a
sSVHU4CsTN/3mWn24jpznn9Z4ZEQ9x3rmTHVezNP9T2q7RfcJQtcl7K2JCjv6fsZ
QJEnQa9ifTqnniDkICVX
=Nv5s
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
