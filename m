Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3LCSLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:11:05 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60520 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3LCSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:11:01 -0500
Date: Tue, 3 Dec 2013 18:10:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131203181028.GK27568@sirena.org.uk>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
 <20131127152042.GY14725@sirena.org.uk>
 <20131127152358.GP3296@lee--X1>
 <20131127154221.GZ14725@sirena.org.uk>
 <20131127161323.GS3296@lee--X1>
 <20131127162859.GD14725@sirena.org.uk>
 <1385993555.5573.3.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0dA3wbhdegQN8Av"
Content-Disposition: inline
In-Reply-To: <1385993555.5573.3.camel@AMDC1943>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/2] regulator: max14577: Add regulator driver for
 Maxim 14577
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0dA3wbhdegQN8Av
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 02, 2013 at 03:12:35PM +0100, Krzysztof Kozlowski wrote:

> Do you wish me to change the patch to previous version using
> of_get_child_by_name()?

It'd be more standard, yes.

--o0dA3wbhdegQN8Av
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnh6RAAoJELSic+t+oim94cUQAJA2BhUV63rITb//j/++KGYM
m1wxTeby0VwA9tG2riwDTLqfzhQMC5buSW6iBIainby/2i3gvZM6GgtRwi4pIWjA
+cFhQvJRfZ4G967xiFQOBbPnsT/2TKkwePmX1rHEtmBDirm9H8w8+9rZ8Alw44o8
N6ahw7gsVp6tEeYOSS4faz+5JY+LN2M0ci2x9QaEEtu9babfrAqE8bAsc8d/4b2d
oQb5nX6e8WUZIxpyGNfTpLFaqd1gpYiXYjeU8UgAL9UWO1paN1oyveNaDRLu+gt9
VhPGGruolQoBKQhHOprcaA2IWvVOI18VbWBWa611s0Kj4OQUG1lN7dwegudiS/hH
7rEffrAPybCAKYQpR3TeS+NJWZsRBoy1HdAA11qE9VqawXUGPL+6eVtOAhFvIGj4
r6jIk29TO8a/uHENkBFfaNCZRpYAHgWCir8l69GG9fik5CPEbNtuOpzCIl3W4tWR
k8COVCDtHw3M9obK2+G+tT+NUEUWIJvn4K+lVOY+eR50J0U7x4TC+T3Od42i0zcO
sPdVyVRdMRlSiQ3iKH7Uq3uME6535ijZ0Y2kajPlZPjaxVwLPAHsucENDCWPrcdL
vLnNX8n4ofd/g5wezc7BPJk+oOotMtlAWV/LOaICXl3FXarvw3UCEvH4ri7BEoLR
nn80v1D7cz9Vecf391QT
=EwAT
-----END PGP SIGNATURE-----

--o0dA3wbhdegQN8Av--
