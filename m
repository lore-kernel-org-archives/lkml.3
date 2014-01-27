Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaA0X6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:58:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60434 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaA0X6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:58:30 -0500
Date: Mon, 27 Jan 2014 23:58:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>,
        linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Message-ID: <20140127235815.GA8513@sirena.org.uk>
References: <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <52E58330.90602@roeck-us.net>
 <52E58656.7000903@roeck-us.net>
 <20140126235103.GP11727@sirena.org.uk>
 <52E6951C.60609@wwwdotorg.org>
 <20140127185031.GA28910@roeck-us.net>
 <20140127230447.7e8be3a4@endymion.delvare>
 <20140127234135.GA18059@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20140127234135.GA18059@roeck-us.net>
X-Cookie: You are lost in the Swamps of Despair.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 03:41:35PM -0800, Guenter Roeck wrote:

> I'll test Mark's two patches on my system and let you know the results.
> After looking some more into it, those _may_ actually fix the problem at least
> for systems supporting ACPI. No promise, though, and I am not sure if that
> would be sufficient (it may still not work on non-ACPI PCs). But then who

They should fix ACPI systems, if they don't we need to fix them further
- that case should just work, it was an oversight not to have a patch
like the ACPI one in already.  I'm not sure how many non-ACPI PCs still
exist, we're definitely talking about things over 10 years old (even
before PCs became ACPI only they started to have ACPI present which
should be sufficient).

Jean, I'm doing a writeup but it's probably not going to be done today.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5vKUAAoJELSic+t+oim9wLcP/R8LJH3pVAXgEmoxfFtXZoyx
ampqgioJBoky3jU48me3O9rHHRPAbWr2JW8GMBtfC+VmnHKGlBj/ogUtfPfs9dvq
Mqp/SPe727ey2fsg+qgFPqhMPH1/Fd/mnSSbbkMLsrrDTJm4Kx3asgkuXZCQzXR7
NWAFkDscNxOJRpPfMWqVwisgr/6Bx8u+eGxe+Wrghw1Qcjv9HzjvG3wMwfRjVWhc
zzazcaGIJFW1nFc0qYAdLFTwxhuSV2lfBZBr3agBLeTtj193cKB1xdiN1TrxTBlP
LoBhwzwEOKNTYo4HgS0xmgALaz4gFW6s2toJtHMrIEALrE4PIpY2Y6NgO42SwwOQ
mG2dd5sauMuyYNdPSkP0B50PFLH9YeD94rh9jFDcGndpcOEoP51mpgmhjn7Vnpbi
4xChHZj4vj2M/Rg+8dkThXjFykZNmj4qgulnkOukmDxPeMDghzrJqYNUPC8O88cX
gEVZYiPptSTY82GQfOcJftLxUin6xGeH45gKbX4WUoz6x25WcUrGjeskY08AlXoh
HrMSNezB5Zk+mxrpbSzGVUSsoqCVJR4tphlQfsRR738Gz40D9GFO9xrZO0Fpxr/S
3sK4xsI+UYuNCiFXYsgkilKpqKBRBDG1lSwOu3VDtOdrH8J4qpjGhrBSGVhHAnnT
/dr7fsbDK4eTZEIs/w4x
=fPqD
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
