Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab3FMPHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:07:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56150 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3FMPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:07:19 -0400
Date: Thu, 13 Jun 2013 16:07:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <20130613150710.GZ1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
 <20130610164905.GJ1403@sirena.org.uk>
 <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
 <20130610180150.GQ1403@sirena.org.uk>
 <20130613133950.GA32174@kahuna>
 <20130613144726.GY1403@sirena.org.uk>
 <20130613145803.GA32324@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DHs1QIiRxKbdokJu"
Content-Disposition: inline
In-Reply-To: <20130613145803.GA32324@kahuna>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DHs1QIiRxKbdokJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2013 at 09:58:03AM -0500, Nishanth Menon wrote:

> I am proposing moving the following into OF match data.
> ti,i2c-slave-address
> ti,i2c-voltage-register
> ti,i2c-command-register
> ti,slew-rate-microvolt
> ti,step-size-micro-volts
> ti,voltage-selector-set-bits
> ti,voltage-selector-mask
> ti,voltage-selector-offset
> ti,non-zero-voltage-selector

> The only thing I propose to retain is board specific variations - e.g.
> gpios, boot voltage and standard regulator min,max overrides if any.

> I can also do voltage selector based operations while at it.

OK, this sounds like a step in the right direction.

--DHs1QIiRxKbdokJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRueAbAAoJELSic+t+oim9+WYP/Ri5VQAejxUGpiXFfWDdpNYs
gLqnhF5nGzNVGpc/Z3Uqwir3jDYWk+GzpJCx/KVUD2XPzp104F+8sI6cCzyNPOGj
6rzS0n7ZXCCeI6p2SofVUk1XqMAFEbk0U2NTBopIcnex16tlpbVcUQxsljjlMwYD
4KCZtZPtuuZIQSHWcbR4PWk/GYmEndvupQiRUoYFXhQZR4CpFfda5H9Iy8JhjE5s
/T2NtJenFPKTNUXHqRkTRbQjzkOL8hZthpClRU5ljaHICbuG0YCzUGOa7QYmZHPU
wespTCTCvFOfrvfW6f84pfJM5Gnyjr3fwFQ50LuVDdKg0Db7e4158HtQ+j42g8Oe
9Uez70obwsfPfnR/VnfqrhHZbZctOiql30j3PKx4QOFuJR28eDIt+GlEGAYo2DbY
SQJqKkY4MXLskI8nBc2QWXXqtKrOQxDxtOaWhcEoEVTYV2flknPBdl2GN3T5xPLq
2pJt0aeIRa8qdx5EXXmGxiKsBc1gl3lBa266vebYdP2El+Cr3ep4JRGislf5Kr4W
Qh9WZ4BkSZ7VuHR6hbWcldtjBWMCIiPv7jjkbb3sQTuhnsfnB+mYKjQDW/myma9S
FtSwuFYWEfYG4n9ZXaxuB7duaAyN9a/xyKdxjSR19UedJShVRrwnsrODFP5ioqlT
w1icF+hRrmiIrFGlzjKr
=lKxq
-----END PGP SIGNATURE-----

--DHs1QIiRxKbdokJu--
