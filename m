Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaJMKat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:30:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50091 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJMKar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:30:47 -0400
Date: Mon, 13 Oct 2014 12:30:20 +0200
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141013103020.GH27755@sirena.org.uk>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-7-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSQmAjgQTjpDdTby"
Content-Disposition: inline
In-Reply-To: <1413042040-28222-7-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/12] spi/atmel: use dmaengine_terminate_all() API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nSQmAjgQTjpDdTby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 11, 2014 at 09:10:35PM +0530, Vinod Koul wrote:
> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon

Applied, thanks.

--nSQmAjgQTjpDdTby
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO6m7AAoJECTWi3JdVIfQmjgH/RgCPG7dptur9uhOE2CrbMfF
be8ufFhosYhZQWknXMWMgEZwO8HLQTkKZ5QOHRsstR5Ri/lTfmdJyFgIxWKf0p/Q
M5NspL+9lLZ3QDWm+VXtpd9/wh+vetKffdRq1qy6k7WYJAH8iYcy/d3iyi8Crmb7
7rOEQCAL3gE3kUZuxMpHnSCaVRXd/I1HY5auRqOVQApHPkCOqPRa3cQw8Dzg6/FZ
i7WTIW+oOzAJunZq3cxz4CoIJKnub/ab80aVaLVSpxaIy9H8myBlMOY4SQL7usaM
wi3beQK2hZxQmv7rdnZbxF/HXjCepTdwM/AaCqpx6dSCcIgFQxWcqZ8Jead66rU=
=kzFp
-----END PGP SIGNATURE-----

--nSQmAjgQTjpDdTby--
