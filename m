Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbaH0TPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:15:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36499 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935490AbaH0TPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:15:50 -0400
Date: Wed, 27 Aug 2014 20:15:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827191526.GS17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
 <53FE2446.3040402@gmail.com>
 <20140827183733.GN17528@sirena.org.uk>
 <53FE25EB.7060702@gmail.com>
 <20140827184705.GO17528@sirena.org.uk>
 <53FE2901.50508@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ii+rdjzNWcC1BLUd"
Content-Disposition: inline
In-Reply-To: <53FE2901.50508@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ii+rdjzNWcC1BLUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 08:52:49PM +0200, Tomasz Figa wrote:
> On 27.08.2014 20:47, Mark Brown wrote:

> > I'm not convinced that's worth it - chances are that if anything changed
> > the mode it was a previously running Linux which will most likely be
> > doing the same things when it starts running anyway.

> The previously running Linux would have changed the opmode accidentally,
> due to hardware design of PMIC chip, which doesn't allow powering off a
> regulator in other way than setting opmode to OFF.

> If you provide the "active" opmode to that Linux, after a warm reboot it
> will be able to power on such regulator to correct opmode, without
> defaulting it incorrectly to NORMAL.

This is in the scenario where the previously running Linux changed the
mode to something other than normal and where the freshly booted Linux
can't figure out how to do that when it needs to.  I'm not sure how
plausible that scenario is, or that real systems would handle it
robustly.

--Ii+rdjzNWcC1BLUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/i5KAAoJELSic+t+oim92xUP/2U48tePsQeLADPGXqKX0zLp
9JZTNy5JiXkgmxD/KoEJfhyfzHZjvhPmSgnwvVeBneOWTbbvTQlwvwVj/YQSD9d4
1EI2YfDnEQMDigfjz2g822LaNwV2YbfjQc2wCqmHiTL2ZZ4RsmCstYjOq0LUaSsJ
+E3eh29ubNnc1gyQJw1aOVo43rAQjKR6aAbCiCWcVpDFjqKEUJV1icSOa9jELY6Q
DKzlzwM30/hdzjo7m9OHnYqYgOjUH2tk+lka7IYBPTXcIR/ZgqisJJcpWfaCIFY+
29KDAFh+wzSYEhOEhbPdqy/HIVFuIENuDXuwsO8ngJ2Z0/L1hXj/uQMwiCFxVO/D
Ated4n3C7cYncD0qKu6x8uTn0wIAYoFf8zVZYBPRpdUELiBniPaCK4A5RB4b1N5f
LTSf77goXEOUNKxKDTLtz9F1UNM+rwCPzxouu+qX1Y2Ly+tREBLK3aTTeuAwtVsm
Co3p+0TFyPnt+4Ou7JYT39aofpabJjWGAEU9c4Jtr6sZZ6uHR6XqUHsbm8JCYdfp
h6eJlT3gFUDqio3WzmBOsCb4KF8xsSPYAZrJCEE7dvznYQ5gDC5/iPeKo4qfJjPy
WI+nhzXXMF+sluZ4MdW26YH+anGFFmMDBd9jOb0mEPz9a88OmzCDfzhxQXixF3U2
LkXRomIc2ujfo1qlrCuz
=susY
-----END PGP SIGNATURE-----

--Ii+rdjzNWcC1BLUd--
