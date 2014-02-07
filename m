Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaBGMOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:14:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37684 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaBGMOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:14:03 -0500
Date: Fri, 7 Feb 2014 12:13:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, lgirdwood@gmail.com
Message-ID: <20140207121356.GX32298@sirena.org.uk>
References: <1391625360-1827-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z8OPzjJiggy3JOV2"
Content-Disposition: inline
In-Reply-To: <1391625360-1827-1-git-send-email-badarkhe.manish@gmail.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: tps6507x: Use "IS_ENABLED" for DT code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z8OPzjJiggy3JOV2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 12:06:00AM +0530, Manish Badarkhe wrote:
> Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
> option for DT code to avoid if-deffery in code.
> Also, modify code as per coding style.

Applied, thanks.

--z8OPzjJiggy3JOV2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9M4BAAoJELSic+t+oim9ThAQAIworH3PXZadgMPJc0tvqaQI
29q93CKafwfDluu1fqtOdPGRk3eSW1ykfgHYTOFPpS670fNGVNxIAGLrFVsHu4c8
GS7KX0bls/niSr/m/uS8+pSUS4fzGiqFDy3pwpVRApNcq84MPHB7ESjeQKU6+Yzj
SjuXapO0pK49muEnXKA5OXXV2s+MExe/aJTMQyCHnOoqzawju4OrKedE6vg9s8ar
PI1J6YWeTefqX9Q38nQD09mdiDBT7M86FV/6xSy0qazHMrSjxii0VNiHInU4S4H8
EM9zYflE4wCJsSzMkoMEqtn9w9agkz04eC9Fxs4QsRl49lAPy305LalNj9P3CSdC
h904ltx9nn59bVFZrgpkHg52IOcArp8te+28mcgBPNlbx/8UcoCzfMwBrEYseUZL
2fXnCiyN4GffKABYGJ8ODrtKcvtsWE1r6RNF1rumqFVXVgxzTZzYjiYPUPh0gX3l
J4HyLHXtgq35XqQyDT3y6gfyqveN/UoPv4J0+CWhFSTv9+Zx/NDG9UJef6Hlhw3i
3y4D+pagqaV22eD297F8ntPS/LqQHN6uR75rnY+wgxLmPX5Sh/R9pqfqXzvy97F2
4V+wGrm3grRuZNJHbB/OqgckVKEQvZtzzxCh8nkl/IIwjLHXy3YBFQ7KYGjHOSmh
NfBNZNPdMqvABbSRiNKd
=PQVQ
-----END PGP SIGNATURE-----

--z8OPzjJiggy3JOV2--
