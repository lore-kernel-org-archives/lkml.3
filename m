Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaDRRoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:44:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38195 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaDRRoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:44:11 -0400
Date: Fri, 18 Apr 2014 18:43:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Michael Spang <spang@chromium.org>, Sean Paul <seanpaul@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140418174353.GX12304@sirena.org.uk>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
 <1397689950-1568-6-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5k1w+INrEpMj7n9w"
Content-Disposition: inline
In-Reply-To: <1397689950-1568-6-git-send-email-dianders@chromium.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5k1w+INrEpMj7n9w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 04:12:29PM -0700, Doug Anderson wrote:
> An issue was discovered with tps65090 where sometimes the FETs
> wouldn't actually turn on when requested (they would report
> overcurrent).  The most problematic FET was the one used for the LCD

This is basically fine but you said it depends on one of the previous
patches which you didn't CC me on so I've no idea what's going on
there?

--5k1w+INrEpMj7n9w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWRVAAoJELSic+t+oim9SKYQAJQxhKVMu2NZbi8iY6fnEt9d
nUxK+RKjsY5suXVy3TP0txJw+LrVxesvtv2Bf1VAVx80QjTanOTJLgmVd6FT2ezE
inA3eSw711cEE6byPbLpkaj6+p3MLxNqifFxyLwVudHtAMv9sY4orHwpjtlzsG9e
yR14XYmBxBJLINxMo601mzGWS3Z+K/Wsq26D23OFGv8jlySgZlqm2MI2vITlhTy8
gRTn6cl2mahmeq+p3tVy4rZqVxybweeOAwdWHtCzDPIZ0/pxiJR32odvxaEnEyGG
cOWrSFOsdbeqekBdVW39kOAysVbYT2oslI+RqOzuiX9394JXUk1I8hPqRCG6M0T0
QPB9vOSz1rUU5TTPszOltznBR37XDhRl0xgeIELNf7mdARNSFrzCwqw48wnfNXD9
Z6l14OPOEX2Ip2X2l9PQYx7uSWw35y372XqYRjp1nt0dpeVp8ixEZeKZ14Ty4kXP
tFiq7O1eLhZVbv01auYMo1AWjlZtjjQ8M920/0K9j8x4updzgygesOc2IVhhEUdx
PxeSPODg4owf8OLTWqmGQ+bBEmT1sn5OQxU/Xl4+aaNg+Fhgx3IQMgwXTakjB2D1
l1/Ck/WfRTW2ZXBcUouvF0agQ7Ybt5CHsxQDoCofThiqN/Bb1wj46cqoSCSuaudD
SPKCC46BAs5nUYlgB/Tl
=Uwp3
-----END PGP SIGNATURE-----

--5k1w+INrEpMj7n9w--
