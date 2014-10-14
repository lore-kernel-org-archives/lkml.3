Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaJNH4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:56:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52800 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaJNH4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:56:53 -0400
Date: Tue, 14 Oct 2014 09:56:06 +0200
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
Message-ID: <20141014075606.GN27755@sirena.org.uk>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xvYBvMhxkRoMdQuV"
Content-Disposition: inline
In-Reply-To: <20141014011112.GB2751@jack-ThinkPad-T520>
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


--xvYBvMhxkRoMdQuV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2014 at 10:11:12AM +0900, Gyungoh Yoo wrote:
> On Mon, Oct 13, 2014 at 12:35:12PM +0200, Mark Brown wrote:

> > If you're doing anything here you should convert the code to use the
> > simplified interface for parsing regulator data based on putting the
> > subnode name and regualtor name in the regulator descriptor.

> Thank you for the review.

> The driver has of_device_id.

> static const struct of_device_id sky81452_reg_of_match[] = {
>         { .compatible = "skyworks,sky81452-regulator", },
>         { }
> };

> And the MFD adds the driver with of_compatible="skyworks,sky81452-regulator".
> MFD core maps the device node and the regulator driver does
> not need to parse the subnode name.

No, that's for the device (and as I say I don't think this is a good
idea).  I'm talking about the parsing of the constraints from the DT.

--xvYBvMhxkRoMdQuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPNcRAAoJECTWi3JdVIfQHa0H/0Iycj3P7jFC37wp4ebnDZlx
0X1UlSpJOf8JKOY1NwqifrOwQDtyoKCEXlpCdmEwW81yFeRGKexq4hoFpCa2x7WY
Q6Tdube51ZRfZmmCBTssomNhrBpDuXW5qDGEaZ9bcib6lJeOsZvjNr0uxVovAg58
71j9dWMjv+/t4nLx/cX3HvEi6ppoYrSMhynh05Seo1gUPgis0iKYeR8oPG4KUq7k
RdMY9xK8x3v3/U75S2E3Uqk2NwsLKYBfqW0niqZjJyVbX3KlRMg11lxksNFP8fsj
oq3P36/53D1RK4scdDMPHQLI1GwVc9dX8xVlXvZMOjQpDjDwWAT4gRYkqU/89r0=
=hunQ
-----END PGP SIGNATURE-----

--xvYBvMhxkRoMdQuV--
