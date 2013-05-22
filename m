Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3EVRp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:45:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55623 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3EVRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:45:58 -0400
Date: Wed, 22 May 2013 12:45:16 -0500
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130522174516.GT1627@sirena.org.uk>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
 <1369226853-16978-3-git-send-email-lee.jones@linaro.org>
 <20130522155347.GJ1627@sirena.org.uk>
 <20130522165353.GB18714@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OFqRauS4h7B9gLIC"
Content-Disposition: inline
In-Reply-To: <20130522165353.GB18714@gmail.com>
X-Cookie: You will have long and healthy life.
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


--OFqRauS4h7B9gLIC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 05:53:53PM +0100, Lee Jones wrote:
> On Wed, 22 May 2013, Mark Brown wrote:

> > running or not, the worst that should happen is that the state can be
> > read back.  I'd therefore expect the fix here to be in the board side
> > code that enables the regulators.

> It's both.

> From the platform side we have stopped passing the external regulator
> driver's constraints for Snowball:

> https://lkml.org/lkml/2013/5/22/280

> All I've done here is stop the ext driver from crapping out with the
> misleading error "Configuration error: size mismatch", because a)
> it's not an error, it's expected and b) It's not a size mismatch,
> instead we have chosen to keep the constraints back in the Snowball
> (and u8505) case.

OK, so the regulator driver is buggy and insisting on having constraints
passed in for every regulator then?

--OFqRauS4h7B9gLIC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnQQpAAoJELSic+t+oim9/1oP/3JbR6vPFzPMt9eqpyTrUiwL
U54m4JEf/8n5gO98GoltDLSJiUKu3VB/Blkjwk0m5/hTBgHmA8Hep4ekflC/Kx4/
Sw7mo/63vx7kMDtPCWQO3g1/fES/haBzNu4izx50BdgZjkOVIzFyqd2GrlYm0int
SU7342dGh+BuxILiJZ309WH7koX/MqM6hLAe5sIrYk/dIMXvEMO9Wp5N2x5sKiHb
Py3P6xGlqQEL3j+WNYUisjB90BZoZFgJ+0F1iIRpFxSCaPFQcXDdb57aCYT6y2n1
LTTTpNMqJgPFDxkEalbvaF8WcVdOJhgaQ6bozWTIkTsPQSEARnhedpA9NM/z2JY3
qaEZ4elLYkcpPsZOz8iB18bQkJU6UhI7T0KjJXHUeLhdqPnS1ijIl49CnwTfiBnp
GycvXo9rnm2k5bQjYEL7kQWaxS/6opj+bA3M+4KN8Eu3bqW47/vlXsXaYxbglzQS
h62UZevxLM2L8XanuLZimKQm42f8LQNAjeHSEx+cd8rWIzXNltxOnvCFKL4gS0sU
MctHvZVL3S+G7ZcgO2MO9lE1BbRHeshzTzwYUFBNU/IGVDqyrk34EazF69ovauey
jiknGz9VYkwJNvnBISLcZOI2C9WUmQguls6yQG0gGnXXmRQyrNNq5hBKWFdc4Mq9
DK+3l83pK+LHDwMcFTIg
=lVfF
-----END PGP SIGNATURE-----

--OFqRauS4h7B9gLIC--
