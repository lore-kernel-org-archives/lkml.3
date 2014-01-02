Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaABL4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:56:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40137 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaABL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:56:22 -0500
Date: Thu, 2 Jan 2014 11:56:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140102115618.GW31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
 <52C466E1.3030302@metafoo.de>
 <20140101210814.31e3f3a9@armhf>
 <52C4766B.8080000@metafoo.de>
 <20140102102647.6efec89d@armhf>
 <20140102111056.GT31886@sirena.org.uk>
 <20140102124331.2bcfc172@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YYdWNcbn0Z2BHBmW"
Content-Disposition: inline
In-Reply-To: <20140102124331.2bcfc172@armhf>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YYdWNcbn0Z2BHBmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 02, 2014 at 12:43:31PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I think we want an explicit object in the card representing the DAIs.
> > This will both be useful for making it easy to find the configuration
> > for the link and will be more extensible for the cases where multiple
> > devices are connected, you can't just assume there's just two.

> I don't see the problem: the 'port' is the DAI. The associated
> endpoints give the DAI links and the routing information.

> As the DT definition has been done for video, some properties may be
> added at will for audio.

> What kind of object were you thinking of?

Like I say multiple devices on the same link - if you're just listing a
single remote device there can't be more than one.

--YYdWNcbn0Z2BHBmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxVPfAAoJELSic+t+oim9XDoP/RnDe4d0oID/uL+K2ANKtwxj
EkN4CLzODsli33xTcZiqW9MrHHOi9ai88eU21OjCcXW2Tht4ylj1S5VH4gXp4VM1
lCTPtHBHQRzwV37bekrYX1VCbtYKe7cXwr44XXtHc/uRctR1NJ4HSLgXGQArJGth
rpVRwVLdnZUc7WTVvZZO+cFbmaNOVVyuzlvgVOGpEPvLS1lPNMbJLdZJ30PBdYQT
A6SsR0w4635gvw3EYClede7oNySScNJSQ+CMqPUJ80l+kRe8mGibMWqNsZyh7n6B
ov76Ur3HqIxSMrHKuxMMCP/7BGxcWAUmvVDONk2XQ1LwnYgdB5ayc/y61eESl/ul
vK57L/5ucJ8D8fWZIgoplfd/mujQij5XxIZPxhz+2Oc9lhNfOXAH7g9dK6hr9M+S
mwlvZWAayQ2Y5vXfRCUwkWUT6bTDVBAOYiu9tFKUNQfOruPSvX2ZTFSZWINPp7Sl
CFuFbkVR9I1INhzBZMx8qXB3cvdfDHGbe8U4Rp8OJjjjB0CG/4nkZ2LI3RSOQ6Cl
Ms24j8bss7oU/xnwSf9XjUX1p8+veN8nwnq66hDyyl0dBZrHByPKCbMUzOQWLwIR
Zm1WBPtma2Td57k6pscF2Qqj2xF3g60v6zEbQ98t/FF3ehejCRBS2L47VgOJ3BDC
JnFVnQ884dMnjQD5oInm
=BkPE
-----END PGP SIGNATURE-----

--YYdWNcbn0Z2BHBmW--
