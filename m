Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3LaMjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:39:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56689 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3LaMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:39:22 -0500
Date: Tue, 31 Dec 2013 12:38:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, rob@landley.net, kuninori.morimoto.gx@renesas.com,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131231123857.GS31886@sirena.org.uk>
References: <1387774621-23968-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oaK9NA/DDdTag9m3"
Content-Disposition: inline
In-Reply-To: <1387774621-23968-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Add DAPM routes parse from device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oaK9NA/DDdTag9m3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 23, 2013 at 12:57:01PM +0800, Xiubo Li wrote:
> Parses a simple DAPM route table from device tree.

I've applied this on the basis that it's using a generic feature and
won't do any harm but given that no off-CODEC widgets are defined I do
have to wonder when it'll actually be useful.

--oaK9NA/DDdTag9m3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwrreAAoJELSic+t+oim96zAP/2Rd5TlnLTCgfSk+Aa4T8Hlz
vYom7mbtQsNgsVxZKqAcZ7sKBv8tqfhuTNPYBbAH7QGRIc8+b5yPQJzPAG/Nz7kk
JKhQbiVRAkp7CXKEakYz3mXPFAIgj3gMoqefEXCez+2YpYOMKGQ3nXBhJ03rT9Jo
AynqWX2+AB1eWDZIk1xJ/X6fYdV/fBeRxd9ECSaUafJEjm7bcgEp09nCZ47IbptF
g1+AbMCTy41b6i2cF8uwRKwIlJ8m0B0toLm92xbP4IONXApjAx63bRMPtCQHrPHK
Lw1yZtTiC9urWYP4QeX6r4AJPtVc9UiVbl8B0UWnnYOKWfkb5fnPKEgVMDIOa9Pi
ytnMmvxwjDnBmlokO/TpYNMZ8SKeq5gOw0IJdP/tUfvRPHPRQUcY1u2LpCnXrnKH
lHUXZ3qBF+Rt0WfkX8zD5X36mXXCx+1amLqUM/iMEWLeOqzACCsGNJb0f+YdSRIR
lmb3CZnncSfCd53Jh5hjLlWWiEG6jNfELMoD+3NVL6x3qT6rqOTtYMscV6SRFJ9+
PC688GZR+f5tsrJdFkTBZYSxpQQup0+JfDe+BrG1yC549+mrApNNBgOqcVpKhdQZ
k/KGaLPwjNQUJVsKQwsbfQJ1ATRHnmpDyt4KBlnbW9lA352eP4T1uRu2u/BShsBX
MOJ4Jilia7yLyhn+ys1x
=bNO0
-----END PGP SIGNATURE-----

--oaK9NA/DDdTag9m3--
