Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AXLAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:00:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444Ab3AXLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:00:40 -0500
Date: Thu, 24 Jan 2013 19:00:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: tps65217: Fix using wrong dev argument
 for calling of_regulator_match
Message-ID: <20130124110031.GL4955@opensource.wolfsonmicro.com>
References: <1358994450.20257.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bPg9NdpM9EETxvqt"
Content-Disposition: inline
In-Reply-To: <1358994450.20257.1.camel@phoenix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bPg9NdpM9EETxvqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 10:27:30AM +0800, Axel Lin wrote:
> The dev parameter is the device requestiong the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.

Applied both, thanks.

--bPg9NdpM9EETxvqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRARRAAAoJELSic+t+oim9VAcQAIfT/m4KFT6Y3rcmvoD1p4lo
SPiT8TumM0AGszng5xTPC07BH/V8AHwUyh9r/SonxttpRxP5wb8FkXws4F0tEuNb
Lm/fb8J+9QwlGBio0eUZ92y/0XffD24ni7C+dX0WEw4VI3EcO1cFKbTuMjrwevOD
rugCuJ1SzEV/2UKEc7qjY4UmxJGFMMm4FNiGxtTtr3CUO1fCRsXGUI6Lm9xFEgOo
jnJ6Pa5jrdyYjCjUMUJNKAuvyJypLDPbS3cReR1gQGIpAxwFoMGfAq169yt+KwIq
Gep6IynrA3akgLqaXDJ2d98Pgmk6qSeFbwWwFhV6LDCX041j6vCdwb8RxUy1tic5
XmfBNDspw1u3T89yWz1At4xhZxZY9KY78awU2TPWSByTfoX43zWHjOg/I8r/kYEH
zZcCr/3Z3uwTl6DzWcXyaaReKmiXQcQGY8wwT5h7z+5UJoQyDRrH0oJlKXOQfJe8
P/JImUYq0RbrpKiVSfbNWN81/8gEwKJDvpwYqE+HoHtWW6vGQ5xKXytwwE942RzQ
lhOKR7wm4N7jX8ZgacQ6kliwSEb1koLKkee41+pyFM+uyC1j7mV9tcmglrqVAdJP
7r+zRi1CpNC+zj+1jLJlEP0U9B0ePANaFRh/S8zadhfu6nsYTSwjm6QKtxZA8xH2
gGzQug8ZSkt+hxxIudEB
=rXKX
-----END PGP SIGNATURE-----

--bPg9NdpM9EETxvqt--
