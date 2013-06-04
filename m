Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3FDRhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:37:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53572 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3FDRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:37:53 -0400
Date: Tue, 4 Jun 2013 18:37:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130604173749.GN31367@sirena.org.uk>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
 <85e2cc9ef188d475c531780d9ee338705a1df673.1370354549.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6ZTfQE1Row3TVml"
Content-Disposition: inline
In-Reply-To: <85e2cc9ef188d475c531780d9ee338705a1df673.1370354549.git.michal.simek@xilinx.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: spi-xilinx: Add run run-time endian detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i6ZTfQE1Row3TVml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 04:02:36PM +0200, Michal Simek wrote:
> Do not load endian value from platform data
> and rather autodetect it.

Applied, thanks.

--i6ZTfQE1Row3TVml
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRriXqAAoJELSic+t+oim9drQP/0PYdm0lZnLnnS8NqfgAWuuT
Lvit7fiNGEjF5AvAj5FtF2MOZazBZGMmIV1TrmtLfupgde0ezoITZexaQFIQYxas
XAjCvp6kVRYVvlfeG6igGo7+d9Sh9/yUWm5plrnPG7XK74dffhof72YfIueLPVqa
zcz+6hnTyauzhKWevVCtIkCvO+9h4qIi2lHwMqCYZd06CqFDLn5bo45KJLR08PSy
70zrw6rNVbxOCedHxurLnELmba5XiTBOSHlDppt0SANV8Jh/MF0BTVCElqYj3omW
UFUXoVwbfS9ePUDVRHnP7SYhCkJZv/+sJPv9Zw8PoajEY3vLPwYCxAfUfS17e3Ev
mRLv7kp12Nje+rKEtDg0IbnFhBOY9QQ4yyC34B7K4FipX36Avp3m2kdD4pbGN5Me
/eHVL9b1cfkcvrokq5j9yVOfe0LRwGKuW2UugUPvIGai5jnUPS0nBhPP4bmlAUcH
S3WxV3FmW+PbCZee9Qp3cvX+BEPyvxopuwwqOPpL7NS84u5Lsr2XfYvfda0H3Hhf
xS2HfdhRbPb4H+Pqz3/p3MsMGFMFW+04YbZ7DRvnHV8zzASnUS384QXv2CXwr8XJ
XfVrRp3TAVaHxRyl+WtuomhZz833i2Juoza+joMj2Njg8kfO2AdLAPSN7IJMGP0a
fhLenXAFpZ9jleItdJbZ
=y3NL
-----END PGP SIGNATURE-----

--i6ZTfQE1Row3TVml--
