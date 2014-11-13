Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaKMSIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:08:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36889 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaKMSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:08:04 -0500
Date: Thu, 13 Nov 2014 18:06:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linus.walleij@linaro.org, gnurou@gmail.com,
        tiwai@suse.de, perex@perex.cz, sameo@linux.intel.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20141113180621.GL3815@sirena.org.uk>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
 <1415901046-3391-3-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Rze0zIwr58YS37C"
Content-Disposition: inline
In-Reply-To: <1415901046-3391-3-git-send-email-rf@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] Documentation: devicetree: arizona: Add bindings for
 WM8280
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Rze0zIwr58YS37C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 13, 2014 at 05:50:42PM +0000, Richard Fitzgerald wrote:

> -  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110),
> -    CPVDD-supply, SPKVDDL-supply (wm5102, wm5110), SPKVDDR-supply (wm5102,
> -    wm5110), SPKVDD-supply (wm8997) : Power supplies for the device, as covered
> -    in Documentation/devicetree/bindings/regulator/regulator.txt
> +  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply (wm5102, wm5110,
> +    wm8280), CPVDD-supply, SPKVDDL-supply (wm5102, wm5110, wm8280),
> +    SPKVDDR-supply (wm5102, wm5110, wm8280), SPKVDD-supply (wm8997)
> +    : Power supplies for the device, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt

This is getting pretty illegible, how about either a per device list or
breaking each supply onto a separate line?

--7Rze0zIwr58YS37C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZPMdAAoJECTWi3JdVIfQZqQH+wZoGeWn8YnovgWARutLXtb9
FBhW5UGwl8uUnNFPwAIljwPCfeKMGieMCgq78KybkmXGMnS2ewf9180gtnSNhriz
U656k4yFTGRn138IMqd54vyCiA/Xp3wAhH/aEHMsZ66H9e4q7kUk1Eipb8rilPIu
WMOAQBjJmnC3SvG585U/Q3HlO68xrZeNjfud5CKQesOswNc5dSsP8izrp6HLSZLa
XVQrHFHhoK3ysHXnO34FX0HjdhMYXG6znVI+bWGGWznr5TeYn9DAZNkwf99wpV4F
qL+zYaS3SuxqcSC1mHvnn3XoO/V2Ahdi7s1Z3ElX7jAGfpx3fNN+S8DSEktHtSk=
=ghzR
-----END PGP SIGNATURE-----

--7Rze0zIwr58YS37C--
