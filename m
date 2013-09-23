Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3IWW16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:27:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35679 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3IWW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:27:56 -0400
Date: Mon, 23 Sep 2013 23:27:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130923222744.GK21013@sirena.org.uk>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1379961043-23762-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7dLEKQsGm0Z6zEmU"
Content-Disposition: inline
In-Reply-To: <1379961043-23762-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] mfd: arizona: Add device tree bindings for MICBIAS
 generators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7dLEKQsGm0Z6zEmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 07:30:43PM +0100, Charles Keepax wrote:

> +  - wlf,micbias1 : Configuration for the micbias regulator, should include 5
> +    cells.
> +    The first cell is the output voltage in millivolts
> +    The second cell a non-zero value indicates an external capacitor is fitted
> +    The third cell a non-zero value indicates the micbias should be actively
> +    discharged
> +    The four cell a non-zero value indicates that the micbias should be
> +    brought up slowly to reduce pops

I would suggest defining a subnode with boolean properties for these,
it's not massively legible to have this many random numbers.  Consider
using the regulator binding, microphone biases are after all regulators.

> +    The fifth cell a non-zero value indicates the micbias should be bypassed
> +    and simply output MICVDD

This is something that should be being varied at runtime in detection
scenarios, the meaning ought to be being tightened up here.

--7dLEKQsGm0Z6zEmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQMBcAAoJELSic+t+oim99G0P/1AsCAN1FIKAjbeToHPzlZ5d
FsoRN/Mi+ESx8KOub/ffLJg8uoM7It3TwVHaY66b9wQ9dn4MtGA1zKNIfaafSZeN
aydOCPhuV39zmsskhXdAZjd+WbrqtVi4NcmjvtPnAPjEAptj3yyzFRzCi1jNK0KP
gnVadiirZuO5j/QkGYX8YO0xoo4j68cdCezyMHAwEP5Y8EU2Hrnf6LFLzcdV6gbP
caJtYe1lplzNWY7RWEZJK76F/Mqy1TYO9x6udSoDMV50G4QyWIJGmVQ7pOG0G+bT
Zg3fYK1/30SHBymPAsgpGdlMnU47H94rIY5ugvNgCNVvcxzYnpehcCF12vE/cDx8
JbSgb5eySZJq2zCgG5Y5QUqD/xOOl2cWafWi0rFVnadsgSLWcy/gSrTOWq1ESjji
fIRWudpRQp5IW0v1qsbwRviHC4FlqBv9jlYIx6mKZlcMZ5Soob+hMdmbiXffakP0
4azBMIqOvjaWnUn/AGZSYqhZAgLxcGWPiemiI5jITjwLgSGSNLc9Don4QsnPjIT9
xLOCb+rE2WH1OVeiDvJSk4ynxo/MFmkbhBtPx6WJ9FiKRPrW1/mcntYh4NIuMrmR
/taugeF5NnpKceaht6mkMFubq9/VfApXCZgrympCy/TT7ygDxKq5pLNPRQdbGDWS
CBuKu6AjwE5WmJ0h+yIk
=qxhc
-----END PGP SIGNATURE-----

--7dLEKQsGm0Z6zEmU--
