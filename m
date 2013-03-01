Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab3CAG71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:59:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58730 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3CAG71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:59:27 -0500
Date: Fri, 1 Mar 2013 14:58:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: (cosmetic) simplify a conditional
Message-ID: <20130301065844.GF25302@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1302251232260.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302251232260.3030@axis700.grange>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 25, 2013 at 12:34:09PM +0100, Guennadi Liakhovetski wrote:
> of_node_put() is called on either branch of a conditional, simplify the
> code by only calling it once.

Applied, thanks.

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFGdAAoJELSic+t+oim9Q44P/jTiIr1JFKxUWkXiGD340a7K
D8yB2hSsJ6o7kvUu1fr/Ar1cdNp4GrCuP+liUT2HCHmWV33VC95vsKlB1+/WCUgM
elKosoUaVOMo+zUzYP+tBnfHzM1C3bbU0gh360YS1H42rnTY/m0Q1/eW30MqA03N
2BuMGMcN1YlAU9WmdiBMC0GlKoOq1NrHOdw+7E7R4NswrIUCcU/xG8Ym9xcAcSd+
OI+BWblGl4pREX9Gft9uqEjq1bOSFgcFSA/ibHn55NOvPbiKEM8/u6T9i0mvGNxp
x42QBJhXCUA5SsE2ekDfJK4/DwCG0OFYNb9YnIzHJiKM9ETEyftz2BDwfphGu4SI
7SoRJQ16IpTuqRVwsTHznDmsM/Vpd5ol8ttRLnRZ2oTqFjWd+q5Je7kUZhIQAn0l
VyDhHpRTQhz4TkOkySPG+9WrOKpdK9B5PQbtdOXjYVYaCcyriPR4NV8UBqECxu1+
3ioE4UwHoOXbaIVZT+3hfe7ZdQ43WNdMN9Sjagaz8PjsScYCw9laQOIzEtb6RE3v
DzBHkCH9ajSfeWHLVvt62t0Y8cmv8HQQY74pjMI+jgUgXNpLNIMjbYMh2vSYyCYV
8AI9ZdP9r3D/KY/PANya2aa1LHYlxLydfgKge83pUUZsyRv6/mxgCT4CGFs94+6e
KGPl2n8/Y7UqBRSU6hyN
=T6cU
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
