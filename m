Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3JRRcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:32:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44983 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3JRRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:32:00 -0400
Date: Fri, 18 Oct 2013 18:31:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, timur@tabi.org, lgirdwood@gmail.com,
        r64188@freescale.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux@arm.linux.org.uk, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, fabio.estevam@freescale.com,
        LW@KARO-electronics.de, oskar@scara.com, shawn.guo@linaro.org,
        b42378@freescale.com, b18965@freescale.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20131018173126.GU2443@sirena.org.uk>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
 <1382000477-17304-9-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9xrpoCjP1Nd9xumY"
Content-Disposition: inline
In-Reply-To: <1382000477-17304-9-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv1 8/8] Documentation: Add device tree bindings for
 Freescale VF610 sound.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9xrpoCjP1Nd9xumY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 05:01:17PM +0800, Xiubo Li wrote:

> +  -- Power supplies:
> +     * Mic Bias
> +
> +  -- SGTL5000 pins:
> +     * MIC_IN
> +     * LINE_IN
> +     * HP_OUT
> +     * LINE_OUT

Things that are part of the CODEC should be part of the CODEC binding
and this binding should reference that - this way the information
doesn't have to be replicated by all boards using the CODEC and if new
devices are supported by the CODEC driver then only that needs updating
hopefully.

--9xrpoCjP1Nd9xumY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYXBqAAoJELSic+t+oim9bgEP/RmwhwxlWyJMLunN/vXk/RpG
0R1ttv9mJYHnc6oPFUgtpQIYy1hobgLuHz5XGyHsALBoFr7x6uDQcfo0VOZN+jcD
WzP4FqmE/B8oWKq4qttFaS9rqN+htmHkXX/sXn4eVdf+TjjewEW6hMXBk7E0brDw
7Wfj5qaqQdDq7vFM7khvkJFyNK4/oJMugOfVoulaxcDt/amzUbYnqr8+Qr7BMNK9
58gk1CpFqU23iPdPlvvyjw/YPcO0RnzuHSUKMIop5xLrF1jrtsbr8Ds0dHtRcQvr
D81QYWT8GJAVosCMVHNAs4Ri4luwNxFzkTTq0dDKmiFrogEoy6YZ798VXGl91hLI
G6eV07hx2eo5P5F6cJ087kHNBF0EE7XFImeh40E4xbmn3RXBChc4PBqc21gH8uLI
U6xeFJPT5Fkca6GzAjfP/e9P+40Z6icCyW6oXpzgPQKr49rmCrc/aQ1g068baA1o
xhLGhg2FMGREj7JiJSgfUJP7doaQjwAEV67Q9JM8X0jtcUsWoo9X5f2asPHSh8Ok
5Xm4wSc4v0TcCAy2CJKBmS0RUxxJ10xKyqyUo/p1cDcEKGzYH8lcjx0DHGjAD7+I
DBaitO9mMeUutJaYZikH5cAS7qvri3e8+H4xeE5hyYddys9Kz01IqjvsdkbTwnjb
bP8WKJg9Q8LQCTw40kSv
=QO4U
-----END PGP SIGNATURE-----

--9xrpoCjP1Nd9xumY--
