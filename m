Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaA0UnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:43:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60351 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaA0UnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:43:09 -0500
Date: Mon, 27 Jan 2014 20:43:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140127204302.GY11841@sirena.org.uk>
References: <cover.1390813480.git.moinejf@free.fr>
 <22fafd7e11771ffc25c84ff609d18039f07b7295.1390813481.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Io5+l5/qWLIGd1Gn"
Content-Disposition: inline
In-Reply-To: <22fafd7e11771ffc25c84ff609d18039f07b7295.1390813481.git.moinejf@free.fr>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoC: tda998x: add DT documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Io5+l5/qWLIGd1Gn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 09:34:49AM +0100, Jean-Francois Moine wrote:

> +	- compatible: must be "nxp,tda998x-codec".
> +	- audio-ports: one or two values.
> +		The first value defines the I2S input port.
> +		The second one, if present, defines the S/PDIF input port.

I take it these are port numbers on the device and it's not possible to
do something like having multiple I2S ports?

--Io5+l5/qWLIGd1Gn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sTSAAoJELSic+t+oim9qhYQAIvBnoUun4PLU6BfbITHYRNb
vNWEBEI3NrYcJGjik5HWEsSiXuXBE7c8LhGHc2WF6/YoycFkWmmhupZIwG1FYit5
Rr7IL6GhtDdgWPDRiR2umGrZijkRowpy7Dr+nrdoWY61W565Sx//gnvf/hes0kjT
OagqXrIfnO7AOkp5ivSwIEah6be+ZsN8++HL/++Q6nkPy3UtH3x838UDB1Fnggzy
CK6iT7DqfsvcppPz7gLci5uW0A1us64jcebgbV2EjvBdCTirYMJ7GPCN1DqF8zW0
O0H1SzvWIIYe5h0/W6gnAYepv9nuG0EZD++7AsaGxzOXgPZzzh3iC5BsH/xD7WCz
u8YHHunQStyXMtYTTbLGoDdmdYeOmk+ZsUGuV6amNASMu+9P/2GNnZuRxZhwaMas
1H5OOaBSD7uWVxsD/Ya8lls8Bi3NPz/QIWW9XrWQccylPy3PJNGQqPFLBJESMbeX
gcC1gV27I89jbZM4tahOq1uYI36H/fUzlM2s/awqLP7SDEcQJAkDh7w8bvoVRqnP
Gqr9Z/WfFuSe34R3YRvIfKc627OG6LfZcXj1c/nKlQsBjCAU2Zf2PfrkEFHgXkfO
aAj9eDdspTwKT+LsCMsORSPgV/A+VvyvyH4GGi/PaddrIeVp3Q4TZJ79nKFArPSQ
aTFbP2X5p5my8AGbRx7q
=7WZ8
-----END PGP SIGNATURE-----

--Io5+l5/qWLIGd1Gn--
