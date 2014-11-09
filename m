Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKIKRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 05:17:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53380 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaKIKRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 05:17:50 -0500
Date: Sun, 9 Nov 2014 10:17:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141109101729.GN2722@sirena.org.uk>
References: <1415525113-25598-1-git-send-email-b.galvani@gmail.com>
 <1415525113-25598-4-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JLiXfqD9/Kt1b+Pq"
Content-Disposition: inline
In-Reply-To: <1415525113-25598-4-git-send-email-b.galvani@gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.97
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ARM: dts: meson: add node for SPIFC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JLiXfqD9/Kt1b+Pq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 09, 2014 at 10:25:13AM +0100, Beniamino Galvani wrote:
> This adds a node for the SPI Flash Controller to the Amlogic Meson
> DTS.

Acked-by: Mark Brown <broonie@kernel.org>

--JLiXfqD9/Kt1b+Pq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXz85AAoJECTWi3JdVIfQG5cH/3A15dIrwZU8ZtnWmeAznIes
0YCa6pASIak1j8iCCGLW5qUXchiMB5ag5gWAZRiZAfuW7K0K57IlRrHYQSsk8jOC
UWK5M0er7jKCTpfgrwfpO1GcOWlNQwo+qCx47M8N2HBK6cSH1AC3WqhzZmyn6anK
HnV+858F6PoBlRflAhRJNVRyF2MIS9DqSS4hYttsUrWiiHxsz3jmnsgZr4Z6thjR
VegzJ354je2zaKhEPPBL+s08xwRN/1EzZ67KFCYWLfgMA7uMwRk6F4BuxfHEqOs4
K0+qlRjZAJJpIiD/3aCF124O9Kfu7Ar+ZTJosEcsZt61UESR4StW7uUOWcqpMzM=
=sG1B
-----END PGP SIGNATURE-----

--JLiXfqD9/Kt1b+Pq--
