Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaIHVWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:22:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57867 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaIHVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:22:08 -0400
Date: Mon, 8 Sep 2014 22:21:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20140908212143.GN2601@sirena.org.uk>
References: <540E1014.8090102@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FhKpTYimqQF2+bfE"
Content-Disposition: inline
In-Reply-To: <540E1014.8090102@codeaurora.org>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.156.194.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] RFC: add function for localbus address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FhKpTYimqQF2+bfE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2014 at 01:22:44PM -0700, Stephen Boyd wrote:

> Where is this described? From the commit text that introduces
> IORESOURCE_REG I see:

> "Currently a bunch of I2C/SPI MFD drivers are using IORESOURCE_IO for
> register address ranges. Since this causes some confusion due to the
> primary use of this resource type for PCI/ISA I/O ports create a new
> resource type IORESOURCE_REG."

> And the comment next to the #define says "Register offsets". I don't see
> anywhere where it mentions these are CPU addresses. Certainly the
> current IORESOURCE_REG users aren't CPU addresses because they're
> SPI/I2C device drivers.

Right, the intention was specifically to handle things where
IORESOURCE_MEM wasn't appropriate as it wasn't ever going to be memory
mapped I/O and should be in a separate address space.

--FhKpTYimqQF2+bfE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDh3mAAoJECTWi3JdVIfQh9cH/02T4h6Y6ZA1T3XlNeTSvIJ+
tZ8O95PRWz4Kjiu9m6ZrbR12uZ+yNFZfWq4CXS+X8nUhR71u3qa+kyiun0VEQ2wc
xEPWL/p5+DO8hWgG1Xr3qejbpAGj115fwZMHuWM3oXp0AmnFf/qdzgRvGm2EcLW1
QeVWIyYEN6EGPu0KjCaBL0nIBIacxHTSZK05WO+pjrLgXOfknlmKOZt2pHOIs9i8
WkQK0Wg9GO/B8g6R1sVgLeD3NHzOJY8dvgzhB/yc6s43zmGHV2ankKoI0jnYkUEs
4EWGQnpvcLMhGMVor00qfq3vQEO7TziZGrWY+aehc4LOqHYGlWYAUNHAxVb3bN0=
=h2Dc
-----END PGP SIGNATURE-----

--FhKpTYimqQF2+bfE--
