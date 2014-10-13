Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaJMKf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:35:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50126 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaJMKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:35:55 -0400
Date: Mon, 13 Oct 2014 12:35:12 +0200
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141013103512.GJ27755@sirena.org.uk>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KOBxLkMFRQI9H+bc"
Content-Disposition: inline
In-Reply-To: <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KOBxLkMFRQI9H+bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 13, 2014 at 02:47:41PM +0900, Gyungoh Yoo wrote:

> -	np = of_get_child_by_name(dev->parent->of_node, "regulator");
> -	if (unlikely(!np)) {
> +	if (!np) {
>  		dev_err(dev, "regulator node not found");
> -		return NULL;
> +		return ERR_PTR(-ENODATA);
>  	}

If you're doing anything here you should convert the code to use the
simplified interface for parsing regulator data based on putting the
subnode name and regualtor name in the regulator descriptor.

--KOBxLkMFRQI9H+bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO6rfAAoJECTWi3JdVIfQ9qcH/jzv0A79AYL4sIdrwwwOSc/e
IUxPbRYbjmlK7e+TAjP8NmNOqneuJjgV2MUbNai1RJadQfcRbiz5PjGYBWPEZ5rK
+DOaG/LfjcR7zbPx38GAYOLlkkaerIin0GlOYrfN5gI3nxbP1CNfbDq8iPToiN6D
diRwk4tEV6TOOB0x3hJB0JK7yDODExUz7T56BkrTl+FBFJ2QcOkLoYK5W1MbDF53
JlYddM2P3jdY0jh8BxvKV6gh0uhJTlmXbXAhG7r4e3F1AUGbgcS/cGwMAYhe4eyt
XrORHpshJTc2TOZ02EWtRzQGPSLoQKaXekt3iyc+xSeUHCOCamOc6oGrXAYtFBo=
=gpRg
-----END PGP SIGNATURE-----

--KOBxLkMFRQI9H+bc--
