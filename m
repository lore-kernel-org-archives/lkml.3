Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbaHZIMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:12:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33507 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933894AbaHZIMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:12:39 -0400
Date: Tue, 26 Aug 2014 09:12:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org
Message-ID: <20140826081231.GY17528@sirena.org.uk>
References: <1408887148-7627-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vi7KrP2J1YMdfyss"
Content-Disposition: inline
In-Reply-To: <1408887148-7627-1-git-send-email-lars@metafoo.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix regcache debugfs initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vi7KrP2J1YMdfyss
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 24, 2014 at 03:32:27PM +0200, Lars-Peter Clausen wrote:
> Commit 6cfec04bcc05 ("regmap: Separate regmap dev initialization") moved the
> regmap debugfs initialization after regcache initialization. This means
> that the regmap debugfs directory is not created yet when the cache

Applied, thanks.

--Vi7KrP2J1YMdfyss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/EFrAAoJELSic+t+oim9tr0QAI9Kb6WefKNv006c2vDo/nN0
uEmGvtypvxQI7toHHd6ktmECusspTcfYR8kMHswP5KYfO8NSku3vxqZP7ukYcEQB
K+qHOg1ozMyAHl37LX7cu4a+iw5qvrubFPg+HS/WT7OV/BdEthWSyyiqQT3Yf8lT
isOztKhlXSHGBArodb3vHAEmnz5qPUrvRyJsuqzov72NcBXDo1laV1R0oqm9sgOs
Gg/ur90vKOcIO98l5BGPJfsomy5aVx7P3C7tr9n9vIMD/RFi5moBWgRxf4nhTzT9
R8DeJO/7FM8u3jUFPSYnnC6iw35SpY2cnNUJp1A5RG5KbR8o5B2ux1DOk/9hpYmt
vCI8TkO5WKokrz2Ju9Po7oupc4BXElvGo2HQ7rpE7Fahzdt5EW8hT1RCq4Zg4o+Q
LrTPzDSjv1uR/s3o3I6Kc3MXQxOg8GVtlm2vOq6NBcglNofkedTusHN18E7hMRFT
QXV9pxaaWgiMKk4l6IXSrEYezSsEKdgllB8+dt1cQUcOoxzPiYk6cPZy/tIvNXvh
6otWfAl2Nwp5OJwzX2y5QYlym6WyKIC7WMb4rTQ1JVGu2ycOUqGLhedbB1Hi9aQm
X7AKgdMc6rxZeToHT9x+4K1UKJ6NaXn/yMWMAbszyu+sD8W5jvSLk4cbe9SNWGbT
Ljtouni5cc3rMBMh/iDv
=pFHf
-----END PGP SIGNATURE-----

--Vi7KrP2J1YMdfyss--
