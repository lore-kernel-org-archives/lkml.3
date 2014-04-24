Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbaDXRwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:52:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbaDXRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:52:46 -0400
Date: Thu, 24 Apr 2014 18:52:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, carlo@caione.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140424175230.GG12304@sirena.org.uk>
References: <1398360445-27107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SH1ntKZAXSaMzGy0"
Content-Disposition: inline
In-Reply-To: <1398360445-27107-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: core: Don't use devres functions before device is
 added
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SH1ntKZAXSaMzGy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 06:27:25PM +0100, Charles Keepax wrote:
> The supply aliases for the MFD devices were being added using devres but
> the device hasn't been added at this point and as such we can't use
> devres.

> The MFD already has a function that removes devices this patch uses the
> non-devres versions of the supply alias functions and adds an unregister
> in mfd_remove_devices_fn.

Reviewed-by: Mark Brown <broonie@linaro.org>

--SH1ntKZAXSaMzGy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWU9aAAoJELSic+t+oim9tRcP/Arlf+oR1zAoA8jzoSZtc1wG
PWHFsiRPhmEVC2R4bDFlgA7Loj0byxA5CJBGaIfsmE5APu7k74h7K3VOa8dXKrs/
Se8J4NuS++Tj79rK6bpC0JggTnrQ/l0oqRcQvUuAzGbqmmw0tkK28IZy2zedGaik
mKnHEh1xKJPxXfUtqDn1KQIkdnmyk5CMO+NUaFY5SO9eijg3SMPeEUjUHgCtwrMG
DVAfcVUXzH3hOb/oVegpSQ+R+EGzzDC/ynLZ5sQUyNkFcKJziVKREfcds9CUSMir
UF3biipXpZy5FLu+4+68S4ex+DRVf7TKoR67wXBvEBOTU9S4erYf8SpwjrW90PcG
O2GF9YCskWFkhe2v/kdrpL5L+PAkrq53+Iqf85CnAsM8DAEwsL9yNhVBgr3zBicC
8ROa72eFVVVeGYLShW8NoaCLwdzXp/nFI7woAg1uhkfwUZuW7t3dcm1wct5Y0Tzu
JbD7K5kRkiuI+04niFSfSXxplu+WR6nL8432xTk2p3NCdzO/IyvGs234UA7p1SzO
4oh/5lmOaZMhHXvnV+eZOr7XJQ2IyE77EmqkDIYtQ1I9nsWhWvRMAMr1KQrPdMHG
v06pY6NNEEY7eUypRP7a48Sns8Xcno78wKxta7iJFG3jqm8JlXSv+McgjEhH4beQ
cXlx2pnYCgbn/XDhyD1O
=aaWh
-----END PGP SIGNATURE-----

--SH1ntKZAXSaMzGy0--
