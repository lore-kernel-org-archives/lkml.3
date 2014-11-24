Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaKXS5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:57:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37281 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaKXS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:57:11 -0500
Date: Mon, 24 Nov 2014 18:55:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141124185505.GE7712@sirena.org.uk>
References: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
 <1416669702-7841-4-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7sjjZzazJd4OX9P7"
Content-Disposition: inline
In-Reply-To: <1416669702-7841-4-git-send-email-b.galvani@gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/4] spi: meson: Add support for Amlogic Meson SPIFC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7sjjZzazJd4OX9P7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 22, 2014 at 04:21:41PM +0100, Beniamino Galvani wrote:
> This is a driver for the Amlogic Meson SPIFC (SPI flash controller),
> which is one of the two SPI controllers available on the SoC. It
> doesn't support DMA and has a 64-byte unified transmit/receive buffer.

Applied, thanks.

--7sjjZzazJd4OX9P7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc38JAAoJECTWi3JdVIfQ1VkIAILkSXvspAENmsjVW5ktnEy4
/79f7Gc0md7x8Qig7ixDPY0OXpVBw/3SEFwho+I3E5gcbCakahu/HWe3AvF6G4PF
aFHx+bpBcvnBj731GKXQdNNZXpd4taJyxMqTnO/qEOaBPqS9z149YTCth5T+QVCf
bhr9N1Tjz6GonIHmsq86PJW3eSvM80qQiHCmau2k9pzD2zteTCLS/7uB5dWCuvNb
7f7kckvWogbRyYNUB7BiUO1Fi+m7ORz3yd8a2yaBsNKG6xo85bZmcX7HKO6Pawpp
kzmsvt/9uGbIAlTT7msh6MNwoZRPTBOhc66vGe298nlKV7DZvzOR4eo07PKUAvE=
=7kd6
-----END PGP SIGNATURE-----

--7sjjZzazJd4OX9P7--
