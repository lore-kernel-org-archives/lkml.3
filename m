Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3CYBIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:08:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37323 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab3CYBIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:08:46 -0400
Date: Mon, 25 Mar 2013 01:08:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v3 2/3] regulator: as3711: add OF support
Message-ID: <20130325010839.GH18316@opensource.wolfsonmicro.com>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/zg8ciPNcraoWb6"
Content-Disposition: inline
In-Reply-To: <1363968949-12151-3-git-send-email-g.liakhovetski@gmx.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/zg8ciPNcraoWb6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 22, 2013 at 05:15:48PM +0100, Guennadi Liakhovetski wrote:
> AS3711 regulator OF support only evaluates standard regulator DT
> properties.

Applied, thanks.

--J/zg8ciPNcraoWb6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRT6OHAAoJELSic+t+oim9Q20P/2AbTGRKQ8PUj16sD2sZK6l4
NvBAuX9RsDjkwyWDgcRdODEmAAsV3wuUbZWaws1sbfCcRckJR21Ww0CwFGo0Vzq1
a1WstGbOrTchZDFyx23w6JzDfclFoySpNlFUF5EtXnDTFfASX3Td/1EVyQ2o81Uo
fELDNDnJFsvlG9Kj9+9BNdpVXdPlGsGHnURAkVmM9pe8ADOZp/Fw+BvTumjZ6P+f
NKiuNZMA6RgEdqjDUHggmemTv2Bv1cobQF6t5wZmwpBESRkXC+iAXe60qGwAU9Da
ZunCpWEo9oxKJfGtgLt/vYgoG7tgYW9SFbL87KScQHsOZd9OSnsz3fe5BUhe5Ofa
WlgJdtzCWJXo5p8LpfJq4iyAYsF72j6lTVHN9CbUsGSDwxFx5crfM7SGGN6lEI9m
fNbRdanXIrzJg0r/K5HfTyZeQ2PCjjQqG6mrlnoW1wtN+y9eRZ+xzz4V2ZcEvIV+
mHAliBHAH1u9DnwZFH5Tt0QGFwl4dV0FHb3ZrqYHBY208kH/70Y21yt1xkf7iOii
Kw8QgLmcKpAk8f4r7ORd9qY7qqSu9z26AewsWL5t0R3hUGplBpZlbFfYMjbqGebt
dCKufRiP3a9BHgldsE0rCb7JRihTbcR4mg8l0z4JEuvVX5mi4A7DcR6WjOWJg3Ia
gPKBuAyGyMbFuileh02L
=Cnn7
-----END PGP SIGNATURE-----

--J/zg8ciPNcraoWb6--
