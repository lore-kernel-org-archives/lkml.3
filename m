Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaKXS4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:56:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37263 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaKXS4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:56:11 -0500
Date: Mon, 24 Nov 2014 18:53:49 +0000
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
Message-ID: <20141124185349.GC7712@sirena.org.uk>
References: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
 <1416669702-7841-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CV9g7MldeTA+KTr7"
Content-Disposition: inline
In-Reply-To: <1416669702-7841-2-git-send-email-b.galvani@gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/4] spi: core: Add spi_transfer_is_last() helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CV9g7MldeTA+KTr7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 22, 2014 at 04:21:39PM +0100, Beniamino Galvani wrote:
> This adds the function spi_transfer_is_last() which can be used by
> drivers to know whether a given transfer is the last one in the
> current message.

Applied, thanks.

--CV9g7MldeTA+KTr7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc369AAoJECTWi3JdVIfQWdgH/0bi+oKJ+L9Zc44KLmesnlRK
lRc9yLd5oIcuOm6sEuw7wEP8wfbhO12s3UNOtLSYYjB92bqA1HkzLtoLkJLohOLr
VpqOxRiBMlZwkgGw3uI/01YJACpC/+ckaB8lBd6mfixf2HyNL6pmwJosbhziz+Xl
qkIJS35i55YWoMHjYBEf5h2UKIK8Qn8NZa66vahRT588X8iuLkImvz4AD7mfHK+p
qrqmFP0VfFlG0lvlPaUeSn1ANkJbl4NsBZwtkfgiqFS0iv1kBebLAtnxQdIXkO+Q
lJA/neQ16z+Cg284GoHFZn6VgzbXxAztxizLHgeeEZeGkPy5XRU1AogV8oFYeAQ=
=Gi7Z
-----END PGP SIGNATURE-----

--CV9g7MldeTA+KTr7--
