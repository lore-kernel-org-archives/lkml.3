Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbaGCSos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:44:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45303 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaGCSoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:44:46 -0400
Date: Thu, 3 Jul 2014 19:44:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140703184422.GQ410@sirena.org.uk>
References: <1402666578-16540-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6SWS31fp4apnN2Tf"
Content-Disposition: inline
In-Reply-To: <1402666578-16540-1-git-send-email-s.trumtrar@pengutronix.de>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] spi: dw-mmio: add devicetree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6SWS31fp4apnN2Tf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 13, 2014 at 03:36:18PM +0200, Steffen Trumtrar wrote:
> Allow probing the dw-mmio from devicetree.

Applied, thanks.

--6SWS31fp4apnN2Tf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtaSDAAoJELSic+t+oim94ukP/iPEcmknJZ5Eg5N/0pVKdI38
QklD3rfPW28pESe5dDB/d49tRA7sZmzmLARATwzFOQXaL67h4fNr0EwTACcaZGPY
dRbQ7P57gAB16lT4stwyl+6ZHTeNS4Yunu5q+w3TAm2nzm8004L8ZgtoBsDJasLa
Gh2vjOv2akCtLoiZEGCOZ1DWALWTPPsr3H+ucfkWUCeiA06CN8evGu19Ht32Nm4t
B4RMJCUMl6VrtnxM+h5Yq7RR5OO2tLCFAZ7amgrcDgR9rVClnArIQCqWzGddq1Ba
aHD9s3YI04iuvtRBNCni0+cytZM3R+SJG1mD0hBqR9LmGAasCSmN70y0y8aNFSrs
XgJYMCNGC6HRB/5/t6AEKZYVIC5r1ZxoxsbbYpjA/hI2k/ZBqTtWbG5DAEGQE6IB
8cTe7qVVDtzU9QZuWMABnntZT9nBHYFKSNrsgl+6cgz3MJmVGFeFJv5as8jNa6Cg
WmMIRA+onTcp1WkA8Z59SWYu7M2rcUE+Ms5icWPv/G5xzNSuNrZsKW6ZilK95ivg
uUEdOK9ESJZrda/EgkoJU/noNgD6Rn78iVIg5tAGvUs+m7PZ0Ej6QZ6FEYmcS1dp
zdQJevaShW+luWmyTYsAt248gTw45CPSNy/D8Qf5l6k1LgiKDUnq78sCbjx1EZMz
6hkBqyCXj88NxKJCoOoM
=/pae
-----END PGP SIGNATURE-----

--6SWS31fp4apnN2Tf--
