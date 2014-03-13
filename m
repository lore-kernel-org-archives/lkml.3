Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaCMLnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:43:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42167 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaCMLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:42:58 -0400
Date: Thu, 13 Mar 2014 11:42:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Stefan Agner <stefan@agner.ch>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140313114245.GO366@sirena.org.uk>
References: <1394284559.12881.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DRfr/2Y1Zz/5r+Kb"
Content-Disposition: inline
In-Reply-To: <1394284559.12881.1.camel@phoenix>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps6586x: Remove unnecessary rdev[] array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DRfr/2Y1Zz/5r+Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 08, 2014 at 09:15:59PM +0800, Axel Lin wrote:
> Now we are using devm_regulator_register(), so we don't need the rdev[] array
> to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.

Applied, thanks.

--DRfr/2Y1Zz/5r+Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIZmxAAoJELSic+t+oim9c4gP/0sfzw02EZHoT2kYxScjM5mk
pznQ8dpsnQ/hdB/0mFknRnYWlioj2GtoRhXEHguhY4TSQhfhDrilOLItb+wJRtg7
IEkMzv+ToYKA0NanGOClO5CtZbXaRj+I37nP7a8X64wXWZi7TwT2TNoAB4AjUxGi
85SYEUMDlakXCzo6Kg9NtGwIBmDC9cCpAItX8eSPQcYTIo8lkvyJS2wBetDSUuM7
xzZ8GGW5P5yFnyObszNBMN9ZsolJIsSv0Z7tTRQoGRDU+98ZvBcE+HblEqgVI4rf
FJL+h2oguIBpG5mCGTEHmmK1oRo2M5Q6N9VgkuhqiEu6L0rsUB7hGsIOSveRMmvk
UfRnf+2ApLFY3NTMJBxG017QoOX7DSp1PuZqMb3TgzVihF5Z1HRJqxcwyLmcLG1z
FT9oWk6at93VkQRWpxGAsGn1auBi2RioofzN6IuPxvSPhkFxQ8nyNkpqh0WvyHyV
ySRmBlORRaxBjHPlYEuVR3a+psLJdDPfpNM6MXw8kCa9H9ulWsz9/p5a1pK3Zw78
cpUO46E38W8GZ1y7oooKs31dejVBjfaWr7RZ1rOYhM/oqF7RVfgJqmXifTvBMXrV
4wG+CrmE9wx1gVD4ETeqgE2zbmwKZ84Jd089WfbAzuurZcvLAhtJCqYH+r33iWd2
F327ZjQ8XEiuuvfyWGNj
=sMRZ
-----END PGP SIGNATURE-----

--DRfr/2Y1Zz/5r+Kb--
