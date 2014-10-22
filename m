Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaJVP7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:59:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42827 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaJVP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:59:46 -0400
Date: Wed, 22 Oct 2014 16:59:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh@kernel.org, mark.rutland@arm.com
Message-ID: <20141022155921.GA2344@sirena.org.uk>
References: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Do9hQ/bfCb4zBpLo"
Content-Disposition: inline
In-Reply-To: <1413268273-15151-1-git-send-email-romain.perier@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC v3 PATCH 1/5] of: Add standard property for poweroff
 capability
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Do9hQ/bfCb4zBpLo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2014 at 06:31:09AM +0000, Romain Perier wrote:
> Several drivers create their own devicetree property when they register
> poweroff capabilities. This is for example the case for mfd, regulator
> or power drivers which define "vendor,system-power-controller" property.
> This patch adds support for a standard property "poweroff-source"
> which marks the device as able to shutdown the system.

Applied everything except the DT update, thanks.

--Do9hQ/bfCb4zBpLo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUR9RYAAoJECTWi3JdVIfQHo0H/2H2SwmX3/5xD9ZRF1nfYM5K
l8R0IES9Ks0yKogjfyC7buNJNCOskrLfB1dqqQFPMwxKw9UsqwFxy/MkK+7iV0EQ
MWCvC9RZiJDpE1QRJJz5exb3pDJuP/kb70p8Po6dWAPHuW+ooTF6p56DfYrBiGBa
y/PyCyA7le57z6x1uJojdgjAGyZFosXluyh9PJLLVglzKYzyqexuWIKCgr6ZuI1a
pUg9L81yclXGBm9fiqZX8zEhe9pxqcxCpwp/6XJ0Fbf/Rqgete7t2Bgifem5Xl+S
v7yrAfol5/EWz7jlbv1JhKUBog1Il8dzXQSe8NhGaNS4tp+kwkb9tAN8IXW7QMc=
=rxHD
-----END PGP SIGNATURE-----

--Do9hQ/bfCb4zBpLo--
