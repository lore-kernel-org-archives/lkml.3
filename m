Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKQNbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:31:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43060 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaKQNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:31:33 -0500
Date: Mon, 17 Nov 2014 13:31:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20141117133104.GY2722@sirena.org.uk>
References: <1415990912-31744-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xd9y+pRso0hzCdjI"
Content-Disposition: inline
In-Reply-To: <1415990912-31744-1-git-send-email-abrestic@chromium.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 176.12.107.140
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3 0/2] spi: IMG SPFI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xd9y+pRso0hzCdjI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 14, 2014 at 10:48:30AM -0800, Andrew Bresticker wrote:
> This series adds support for the Sychronous Peripheral Flash Interface
> master found on IMG SoCs.  The controller supports up to 5 chip-select
> lines and single, dual, and optionally quad, mode transfers.

Applied, thanks.

--xd9y+pRso0hzCdjI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUafiRAAoJECTWi3JdVIfQeVoH/RmOoL4pofcM7yOMVU3mlwi1
XwF6zz6DHx2LyUX+K2bU/J97wx8qIFToWU9JAnkH7zk31IxRQ/K/2JimsTVsJImG
ENvbOMupJ9tDh9H8MxNBK+QU2ZuLdV1OKog/7yWjHyUxvZGSZgv0lWnZvlzPsuYG
mP+5jD98SLRDF6YMwN23ttBcfUKrKz6P9dGprB2rN4ti2HbrxjPF5gATUs3xQNcS
QZQCXYr2t3uPZcqp72dtpjlahPyVw/KDPzmz6I4IUVVNlVdD6DJBUppCp0G3oX77
dVxOdN4ILowW1cX6+dZfVzEtx4YEkdS8RoYs/SH7Z+rq+VKzee2Ad6dKDQh4HLE=
=Vulf
-----END PGP SIGNATURE-----

--xd9y+pRso0hzCdjI--
