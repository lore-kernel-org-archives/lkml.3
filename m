Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3KASvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:51:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55678 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3KASvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:51:33 -0400
Date: Fri, 1 Nov 2013 11:50:45 -0700
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
Message-ID: <20131101185045.GG2493@sirena.org.uk>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
 <1383289495-24523-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0QGcccuECrPGiFB"
Content-Disposition: inline
In-Reply-To: <1383289495-24523-6-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 5/8] ASoC: SGTL5000: Enhance the SGTL5000 codec driver
 about regulator.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W0QGcccuECrPGiFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 03:04:52PM +0800, Xiubo Li wrote:
> On VF610 series there are no regulators used, and now whether the
> CONFIG_REGULATOR mirco is enabled or not, for the VF610 audio
> patch series, the board cannot be probe successfully.
> And this patch will solve this issue.

I don't understand what this is for at all, you're just saying there is
a problem you're trying to solve but you don't explain anything about
what the problem is or how your changes address it.

> +#ifndef CONFIG_SND_SOC_FSL_SGTL5000_VF610
>  static int ldo_regulator_register(struct snd_soc_codec *codec,

This is definitely broken, it won't work with multi-platform kernels,
and I don't understand what this is supposed to do - what is the reason
for making this change?

--W0QGcccuECrPGiFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc/gBAAoJELSic+t+oim9Nt4P/RNfAEEOA7DMMZvrmhAOlI0I
9G5EyWOsbCUGOMOjwDMp/DY3i06MjBFY+HskbGTLpCWwdLGDSKP13mTR2duksur6
PN4GJTPrcba7U6BRKnZrXuWQYRg/VRaJiVY0uSYdhhm1rH0IzEM+i+tWC77AzLWG
9ZNxTwwVfXo2ZNStmewW6VqxtvV9K44UvpSXOw8pM+2p6cdEfMtUtdaSs6khFI3/
OBil5mdkAAfWL3MLiiXvTyaJNGVoxlaqSlWBcgbWvHtrmXvgqqIuCoV0tnqpg/Cm
5DuOsSwYYjpaM5vwm9YDG7ubdEMDoJybJds2qjh5RZV4FEaw2mx/lve2ZdoN3xyX
x0jBTPsBbLIkOp/3qbsAkHDwcXneVwnnVmbD9dKVCOkI3Fg9kjksX+gbR9Inohrl
7JTZWASuCVPMQvFSDH6yQvsZCsZrVT6vTfCJL/iBx9UwpkdYCWXyKj/E+fwH3r44
UHL1JK2a4qVlJiIJ98l3AUJ0FkuJuEt+qnKQe2OQKajlgV8mr+YTKBFNNOiJTBN8
YDFCGymYN8FTKjTCvGobe++mu1UESawUrVghlxgPtCbzqWQEg+oTVddQszYoDmpd
o2tdV1rtVwWOov1AOcYUTKivdH1DbFD6uJjRnif6pL8dlhDX3wlVs3G14UAeQjBE
N6ZZ9FKNT50SjIPKU/0R
=rxDU
-----END PGP SIGNATURE-----

--W0QGcccuECrPGiFB--
