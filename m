Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab3EWOYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:24:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57440 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3EWOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:24:24 -0400
Date: Thu, 23 May 2013 09:24:19 -0500
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130523142419.GG2412@sirena.org.uk>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
 <20130522165353.GB18714@gmail.com>
 <20130522174516.GT1627@sirena.org.uk>
 <20130523070905.GD18714@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OFj+1YLvsEfSXdCH"
Content-Disposition: inline
In-Reply-To: <20130523070905.GD18714@gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OFj+1YLvsEfSXdCH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 08:09:05AM +0100, Lee Jones wrote:
> On Wed, 22 May 2013, Mark Brown wrote:

> > OK, so the regulator driver is buggy and insisting on having constraints
> > passed in for every regulator then?

> If that's not how it's meant to work then, yes.

Yes, that's the intention - it should be possible to just not pass in
anything in and have the driver start up in read only mode (partly to
save having to do things like what you're doing).

--OFj+1YLvsEfSXdCH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRniaQAAoJELSic+t+oim90L4P/jax3BWsP6eoXkH2GFzzBqYK
jFswQ4qDGPnrK8NMCZRReMuGQaOIla8yV0Ghf7aajK2CZvTzXGnTJR/TwqoSLjqK
xtzYbz0U0+MisWFVWK5xjoEgmVEQ/yOWwuMDjasAXOnyFUkQmOt7gh96orQn4LoZ
eh8ii+f41+35rZltoe8Fa2OeuZdgYKRjn26ey7Rv9PYq0eiXNPdrRy8OqbV/pt44
KGYgwKQD6pY0FmRUx+SWEABjDZVZsxwaKfmM9HwngrpbDQEe9EkUGZgrGE8r5DV1
8VXK5Yn+y5qsQ3Q2lNWhI1NguyiDEW9EE8wTYIqGNWPp/+NPBTum6zIvXXnoKPrk
es5EoxMuyGVOTdD5oR/Mjm8Kx10G1Pl0pfLOfweorL0IKtpOjdz6OITt6CIqiBmN
OVfhv68JRJmquwyNeRDj3RWpwEJN4Lhzj3NVfuRxIOtwOWUs9cJQMogF0OYVe6FB
e1ZqU3pZSKjUlGo94E+NaHt6h0cb/2MnUsMrjijN4btg1uGWR+9cIYxX0yYV6pnm
dM/6foxMx5heeXU5P6JqscZutuzElw72oPSz4JdDRu9ddACDeaC23JbrVZaemXl6
/RQIgOC0HRGXdCqmGKX6agt2DTaS0iAloGN4rrj9w2+dOTMWSXN5qfd/4XPXhEK0
969Mun2g8cKvq8Gc5/z4
=ROhJ
-----END PGP SIGNATURE-----

--OFj+1YLvsEfSXdCH--
