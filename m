Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaGaTZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:25:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38154 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaGaTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:25:10 -0400
Date: Thu, 31 Jul 2014 20:24:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140731192442.GM17528@sirena.org.uk>
References: <1406809865-13115-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpp9n2aosfmoKORi"
Content-Disposition: inline
In-Reply-To: <1406809865-13115-1-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65090: Set voltage for fixed regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lpp9n2aosfmoKORi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 31, 2014 at 02:31:05PM +0200, Javier Martinez Canillas wrote:
> According to the tps65090 data manual [0], the DCDC1 and DCDC2
> step-down converters and the LDO's have a fixed output voltage.

Applied, thanks.

--lpp9n2aosfmoKORi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2pf3AAoJELSic+t+oim9SDQP/3hv44TmN/t+A/W7UocQRu4u
Pv1qtjZtfKWgAC1mgzrmXUqol16ENgJzEWBgFNru0duvhTQNrWrNcS6GxUagQPCq
oKRTvkM7Xe5dQueHytu6O/YesxoD6nJJZ+Rf6BTfa2iFKoC0G4A/Agyn00SorwJW
lNHFhBUnhVgMpkcEngKNagSFyL2Vnx/1FgnztKpq37uyU+0+Lx+MsXHOPOwRtVTw
l4qXePZHZ/tDpI2X7qH33LAYsLD3/2N8zbZYxgzkLUQDQOIoLn2l5BvtPFCelIDv
0rTowyRE8VZL+uFClu3iIGINih5RmCzTqj3Wb3EGRrIVGOgELFy4vyWTzvA1FAyl
1m3FFreAKb9hfSY8bBdOsPC4uiThqYMJdoDG/fr7rdDoUHH/RpDHQW6D2rUoLTUn
ipGB7FGQQIBdfEUX/zHaDk/Y1j4iqRykyyN91C/BeWBeWVSuzlguB2esg2LIUSmb
lS7fpGJ3PtOL2E8ZmN+yo/Hroa+ASoOxPO5yQYEqtfIwgIFxTn4bmGsX+QZ9jXHL
CvDbfdunlZ+sgSDt7QACtLBPvS5v0jKUF3cWm3asK0IMd3sSirdKgAgasNzIAJDK
dmLw1JMTXLTDdjGhWoGguPqFqFow1mbrj6PTlZaE3nq4H8kfdCDGZf/JAmmko4RK
2xv4jGXIAxr/T2wbweyt
=nS6c
-----END PGP SIGNATURE-----

--lpp9n2aosfmoKORi--
