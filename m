Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBXFfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:35:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50562 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaBXFeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:34:36 -0500
Date: Mon, 24 Feb 2014 10:24:21 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140224012421.GO25940@sirena.org.uk>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1393011432-28909-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140222021048.GH25940@sirena.org.uk>
 <20140223161159.GA5901@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdRgamFw6JHQm+h4"
Content-Disposition: inline
In-Reply-To: <20140223161159.GA5901@opensource.wolfsonmicro.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regmap: Add API call apply but not register a patch
 file
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SdRgamFw6JHQm+h4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 23, 2014 at 04:11:59PM +0000, Charles Keepax wrote:
> On Sat, Feb 22, 2014 at 11:10:48AM +0900, Mark Brown wrote:

> > This is just regmap_multi_reg_write() I think?  That already exists, the
> > theory was that we're going to get an optimised version of that for some
> > hardware which can stream things and cut out some overheads though that
> > doesn't seem to have materialised yet.

> I had missed regmap_multi_reg_write but the difference here is that we
> apply cache bypass, and that the cache bypass is only applied whilst the
> regmap lock is held. This allows users to be sure that no writes
> from other threads will accidentally have the bypass applied to them.

Right, OK - but it should still be a wrapper for a core implementation
and share interface/naming.

--SdRgamFw6JHQm+h4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCp84AAoJELSic+t+oim9P3kP+wW8xNzI+f4F5AjSZ0NgiYDi
C46dbdOSF9+S67i6WNIS3YBK8v4FJklWFEdeHKWg9tCxlqSWKY3p08BzqVu9vmmo
5EbgqogDRkjKr9Nogmye6SqeERerMyKDKlHyCPFQUpzt25B376yEQJbqcK5mgGP+
6MZ4nkGBZo4cSTm0J8xx/n1TRR8OaZbgHk+kgZ0EXuszrZ2gsoQgNxNm5E0/TyZB
gWGU2N66uTfdYS1HdX/5s/FBS2ShFGw7xg4pLyN5BPdyw1jbrg8TY5d8soTB/Xcp
wJ+V/7hU8kgBqHqx6XzqnEy5jTtNmGvwjbkNzfxBIF+QfFE4OJ3Q7RQjrb9bDIKy
ubfbaaPVdbO97+VR4GEjPe5bCDuO2LQBp0u0TeQDbHPXelSeATsrDEbI9fPluPhK
LuLCE+rQppIjxx0mWxeTHUPzL12CxelsaZCrD3vxMS9p4m4d1ysJ80Rx8eGs9gd6
M6XmnbuwS6iG8Ftk9tK6oC9VfzM0SAvigeicyD7a9UanboIp3FsrS9lhUjjrx2/I
tHvDebeEHHRnfS07KP8pMvubdAxTwRIsZWJHE31pZ63ysPTwOlM9YLQFo+x4Ut6K
51WFMeubxqf+gEUC4f1e2DPx61TFkHLmBL/wdrRGHD2+To9Zy6zC1rwhw6/mWSWR
E1NuoktCNxNph3flVIZS
=Bqgv
-----END PGP SIGNATURE-----

--SdRgamFw6JHQm+h4--
