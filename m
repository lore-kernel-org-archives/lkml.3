Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab3KMQgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:36:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50679 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3KMQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:36:29 -0500
Date: Wed, 13 Nov 2013 16:30:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Message-ID: <20131113163055.GV878@sirena.org.uk>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
 <20131113050017.GO8834@intel.com>
 <20131113125111.GE878@sirena.org.uk>
 <20131113133536.GZ8834@intel.com>
 <20131113145441.GQ878@sirena.org.uk>
 <20131113143101.GD8834@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9o1Xi4ZMQ45MudWG"
Content-Disposition: inline
In-Reply-To: <20131113143101.GD8834@intel.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9o1Xi4ZMQ45MudWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 08:01:01PM +0530, Vinod Koul wrote:
> On Wed, Nov 13, 2013 at 02:54:41PM +0000, Mark Brown wrote:

> > Yes, though I think some of the stuff Martin was talking about will need
> > changes to the dmaengine APIs.  He was wanting to reuse DMA lists which
> > currently dmaengine needs to have built up each time.

> Can you elobrate a bit more on what you guys want to do here?

He wants to be able to submit a descriptor to the hardware more than
once to save on the costs of of constructing the descriptor.  I'm not
convinced this is a huge benefit most of the time.

--9o1Xi4ZMQ45MudWG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg6k8AAoJELSic+t+oim9+joP/2v+7ur1ArziF81LX0Mb3ujr
fDLROLY/aglhlbTL/giThm+O/wdqmcA2yndlZIrVH5tdIJhGSurwQrkuuFNidL/v
tEu+RbPar9dKcNKJgUHYVNWkh6Yz5JxJkNQj5HV8vgVkG1XSqU82PTCH4FBUJl0l
vErAYNk2gd09dQqZ9xzIiIjbBuFbXVGpfi+VxocGRgwc5L2+NhypGk9n1w/QjcTY
wCFNcodvKg//Y9i4GZzaOoGbAqX7awZYom1LECZrNRJGjkloxDb+1Bcdx2zvAZts
RXxJayHEjF/UHrHoOgSxLm2jtmFo1v9B5H3T4+W/52k8mHMc3B2CmmmKEpTbOsCZ
pOGl9r8vddum+ZGrGdR342pDbcaWb5eVoW3SS+SNAykwAY+MJ/A4jnepLUtsGcrs
yDIXMkb2v1fmFpsu3iCF9iS+ptnzP3xcxsj2m/FVtstncA0AdgsY114BSY7EUI5C
XozE9k5xr653d7k8aQgcEJgdIu7T7Y5lTmR+WLUIaIf8ZvXMTVjISMG7Oe0z93hR
DIuvocD5unnqg5iZffAR792UpMYlW6/UTz0ubLHyDba/HfFdXTjsclT97rKNO9Od
ciiXrsWeH8+BGFjfTTcAY+WnYMMuug7DBWI14zNcNlTm75E3hNg8j/d2iTbyCD7a
AzuzjGapsEAP4zCG+wsm
=o5Dd
-----END PGP SIGNATURE-----

--9o1Xi4ZMQ45MudWG--
