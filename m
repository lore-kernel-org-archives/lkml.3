Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3JKLuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:50:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43906 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3JKLuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:50:11 -0400
Date: Fri, 11 Oct 2013 12:49:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131011114940.GD2443@sirena.org.uk>
References: <1381455024.4296.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <1381455024.4296.1.camel@phoenix>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: Remove max_uV from struct
 regulator_linear_range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 11, 2013 at 09:30:24AM +0800, Axel Lin wrote:
> linear ranges means each range has linear voltage settings.
> So we can calculate max_uV for each linear range in regulator core rather than
> set the max_uV field in drivers.

Applied both, thanks.

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSV+XRAAoJELSic+t+oim9mzAP/2+PYmJG6PlRaj25UeL7TYjm
xwl6CHa2ejDmTlLuZG1X3jQ/VnMm4hOFUVI69QYyU+bgCZUSKr/f6H5jJWYlnQgB
PgU23xasYuRmQh0hnkZUvf3j7aq1FEJwQghtkdO2ln8WMYuexkopQj9R44hHJVUW
C/DuMIjpLV3KFxsa+/WiheJeviYSxd90uSRCqE1t45O+e1E6vU8X4edJdZS/1XCD
MmkeEyvfHqcdQSQL1GdJgkY4ffAzcrX9vdiq8b+xZcb02ercDv6JT/036oDYqAam
Gs6disDJAVIMDSaUE4iy14ynDSuBbshpNLBUXSjmw1eiD4gsibXy9alOQfO48Jse
OdCEgeJNSfsEgC/5a2wG0RH6oIBYLVKmK6TDx1TwIPaqwCKg8xvUdI18q2A3RyaP
1R8dedooERN2n7xIHU/vbvkkA245SKOe9mRiLoKAgKTWTX0BpUaBJ1EdfMIiNFVG
SouSF0xZOW5TKQFENFBmo/PyFbPij7jM1MgwhyTQ/WOPU4nRqjtp3kOXidsbaq4z
Q4+7g/YKYAzyLFVn97lWLiXFdRlDd2iXLVs7z8U8SZJwxLKUAnOOMpf7jQ6I2vpT
ska7EbRxEIJTioHfBO3dts5UeNX1cpMZciL7Cv1HSE895ZS7vwqx97u0euGWgv51
aX109xieQ/8uhk+07oto
=Upxb
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
