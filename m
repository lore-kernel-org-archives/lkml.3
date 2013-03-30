Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3C3Nye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:54:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33845 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab3C3Nyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:54:33 -0400
Date: Sat, 30 Mar 2013 13:54:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max1586: Constify v6_voltages_uv table
Message-ID: <20130330135431.GO18316@opensource.wolfsonmicro.com>
References: <1364623049.3568.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCSNDbWtzOodvTSV"
Content-Disposition: inline
In-Reply-To: <1364623049.3568.2.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCSNDbWtzOodvTSV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 30, 2013 at 01:57:29PM +0800, Axel Lin wrote:

> Make v6_voltages_uv to be const unsigned int.

Applied, thanks.

--rCSNDbWtzOodvTSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVu52AAoJELSic+t+oim9KMwP/3+64paEn0CWtYTvOdsGp4KB
HbYF+izwLzq/J8lKkbWoWVY8IemjpsmSs+4SCZwzPnGCjV+KTgn8bHc2TlG9jLOE
febH4S19UukITHDmQX+sRAYMxmQqGWXiHJ/VO43zM/noR4EWju5GvLoUFZDoYOJI
V6lkSNf518Sl1NOnEovFV4JGa2Ab6oFc0hBpCfYWyT9TTYywLwoWo/f7FzHH8qRV
ohckpGVDuIMFpkcPfTDFYlBAT9aCs7GFWGIjwC7yGzv3GDWAf6XvPpox8pX3f7QQ
hYRr3bItG35svcPrBKdqbgzI1AZtpH/1kR0P0s1+2uvbZUGTYJjRdmHOArHg4kdN
sKxSQWV0jFx6sr/ugk/XHEADNbRHtfayxDCzpZlwh3U8jLLEptcyHJzjzJgEwxLU
/0iHTxJ7Y5SNnXV9FeVs5rlbjOc0ETCcbHUiv00DRMiMz88Y84pRpAXBbO1Q0B5M
z2oJpBzqV284yAWN6l+8kD7yNd3nxebz036VrFAMYdEfD6zXOmY3RNJPMHSIy/VG
tlxlbUd11MRaStpYC21/QlBVAfa9fXnNa3VODt+2pb8deVAHueQzLXOd/XiHJnvz
sj9Ywd8rNZAzWdx8iRcOhWbQXdPi+uYn0uPba3Z/GVNecH/xV73Mlnhwwa7xjOw3
PqXcHTfiRqLWwNmulXbf
=godb
-----END PGP SIGNATURE-----

--rCSNDbWtzOodvTSV--
