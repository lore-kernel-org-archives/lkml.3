Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaBTK6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:58:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47205 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBTK6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:58:05 -0500
Date: Thu, 20 Feb 2014 19:57:45 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20140220105745.GT2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WVt2Ja9ZTIogLOrS"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/23] regulator: da9063: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WVt2Ja9ZTIogLOrS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:01PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--WVt2Ja9ZTIogLOrS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd+mAAoJELSic+t+oim9/QAP/ilwrvQqqt1EMjIqjDVL4nZS
n8MCAriyJAKbwyc7HMNj6EXlo8vr6jobWRQxqm3CrCYYkblM/xX/noSk8zKVE9iM
+4uaKhBVpYlgM2UuJ5PAOSi4Bq3Uytzv/bhb1uEku0R+k/od6kY2edWppTRiNMYL
oxR+tknZyxqXw/0xPLfqVOIGzgG7OsRVcQ5THKX1z5g48QG682M4h13wTCj03jzN
+UpKy4j2wetvR62qxlV/D6e+67SxXNw0/SNwOWZ28RCIHLK99RDm9rFjsYXDuv57
kEDFTWtSJu5oBpuniH2ooYImV5SK+99IjjnFYBT+VxXRjjb95XwIUbb1gAx8jzrC
00TOobBaJMiZpcCdQazTFesk1AGsiohCif+nalI0wX4qlx/yPIMPNKN8E7oh3X3f
p3u6NNBk09AhxC7ToNC5ajgi1goXLAZeOXMawOFTzJMH2xM4ejLrY/W19DLvwP7I
L35D2wDrGNlImZlYZrCuRoc7BQ5ybWrpWiqhm7bAQivu17okCY9Z+aMpD126vrtJ
Sc4a/Ok5UN/4jOZ9qR2qLarQXSsqh27G9o6D0U0aBT1cr11MFrOhH7XlbgJ3sw/l
gxfrSuLaiqRDq+DZfpmqpwXmD7WEgFRXR0ToDxaNUIIk+PIrl0evQn8C5+3y1nir
OOvkorAOfftXtgJgFTAH
=T9Ul
-----END PGP SIGNATURE-----

--WVt2Ja9ZTIogLOrS--
