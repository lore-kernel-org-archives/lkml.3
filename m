Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaBGRbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:31:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38396 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGRbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:31:16 -0500
Date: Fri, 7 Feb 2014 17:31:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Message-ID: <20140207173108.GH1757@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <20140207165127.GV20228@joshc.qualcomm.com>
 <20140207171834.GF1757@sirena.org.uk>
 <20140207172051.GW20228@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Content-Disposition: inline
In-Reply-To: <20140207172051.GW20228@joshc.qualcomm.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 11:20:51AM -0600, Josh Cartwright wrote:
> On Fri, Feb 07, 2014 at 05:18:34PM +0000, Mark Brown wrote:
> > On Fri, Feb 07, 2014 at 10:51:27AM -0600, Josh Cartwright wrote:

> > > 	config SPI_QUP
> > > 		tristate "Qualcomm SPI Support with QUP interface"
> > > 		depends on OF
> > > 		depends on ARM

> > Does this really depend on ARM?  If so why?

> The ARM dependency is there for the use of _relaxed io accessor
> variants.

That's not ARM only and I thought we were getting generic versions of it
anyway?  ARMv8, MIPS, Microblaze, Hexagon and SH also define it.

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9RhZAAoJELSic+t+oim9s0EP/2uIi5MFABswcCqy3YRi3CFL
5e9W7eWe6WJSdgS9kVFJdCqRY586ZT8VpbWyKWFwX2amAum611BoB0CoiO2gAHoD
WGBIzDDdVt3lrich4N9+VDxrCnOiTX+ceoVpI+9tRP6N3FKhr8eDuU2QN3DK4C1q
ZCw76NeybQX9BwKiS/Npd8invMgW005GU9f2WKgJGVR6Y/LrKmcBlfUr9R/14855
F0rFo3/I/dwAa/ZjvUHR3p19klhOUYrmiydKULNtqUOVEUw70EyJy/tfn+GRQPVG
gt7DmF7ji0FrTqUXTQz/dwL0n8WqpKiPKyT+Dfc6g8d/dNy4BGac8e6ehdXpqGb0
oGGknhlyI03JeB0mQ+WOpToJgYvjbzPmwftiSPsMX9mVUjUT6POoao8BZ5hRa9dx
WwHlFtV8nO+pHouP5WPX4wL6/Rc5dlkErMAcURE7sgWiBl6wJ8NZhQBgXE62amdZ
0FcQVO/L8E3SCjWX1hOhp5WlPOPr0JK2piMtQFKx2uZF0+iLMn+VDpIptTt1DUYe
yJYbdvdCTsGGgKeooaZC/aiblYsmbWk9x2lFZfI410n6Hvsyus1O0Vu++vFoyoLk
0gxAPYv9r0VD+ZPiqeZgLcitgIywRdeYTTOc+WzNAuWgKRw15h2QilHV3YLTLD/q
ndA1zvzCPtFiqhjHhaof
=Bbch
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
