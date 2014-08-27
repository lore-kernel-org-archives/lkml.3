Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935702AbaH0SrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:47:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36443 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955AbaH0SrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:47:19 -0400
Date: Wed, 27 Aug 2014 19:47:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827184705.GO17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
 <53FE2446.3040402@gmail.com>
 <20140827183733.GN17528@sirena.org.uk>
 <53FE25EB.7060702@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dP17qLfgq3afTBmP"
Content-Disposition: inline
In-Reply-To: <53FE25EB.7060702@gmail.com>
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


--dP17qLfgq3afTBmP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 08:39:39PM +0200, Tomasz Figa wrote:
> On 27.08.2014 20:37, Mark Brown wrote:

> > That's essentially the situation the patch is trying to fix - if we boot
> > and the regulator is off there's no way to figure out what the operating
> > mode would have been so we have to pick something.  If you've got an
> > idea for something better to do...

> Probably the only way to correctly handle this is to specify the right
> operating mode in DT (after defining a binding for it).

I'm not convinced that's worth it - chances are that if anything changed
the mode it was a previously running Linux which will most likely be
doing the same things when it starts running anyway.

--dP17qLfgq3afTBmP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/iemAAoJELSic+t+oim9v5EQAJgK92JNMRuh+WwMQGW4yp/U
tES7MrQOGTxyPLlTgHuay66KoBBdfgxOHPVB4y6Sosk5aynaF4rO9g84vekHT1WO
cUo9wwUV8OBaRtNjAmHB23ysMv1P14fy2twFeRrfufOaDjdEbsHnTnfReBYMJ4OC
RqpBSJSDVM6rpmMsYgvqVMua6tDqcwvkn22rzV7EmpN7IZNWPDhmuPxY0rtAiHGF
1BinJgVx36XusYFJWQVc8qiFyeXNLi9OCVrAtEGNijPaIQsSGQc2xfLWv05M6dN9
z+o3SpzEOMOnWuENx4Arez0eITNg+TLeibC7FrjC30M5uLcwESzlH+eNMIsZ60QB
+SzO/WAGPb1aFBvRjT7qnLw06zPwgEvDNTvdUt58atdP3lJFJmORIEJ83cTexhV5
LaOw7LEv9v7n2Qi7VjzFY4xCQRCyXWSj6pPmGbzMNtQ3JPSSpHfZDkLcZtk4N6sN
Ba6PRdJv3vpx5RIbH6u8/1+MTr4N/q76TzXfCUBM9riEJaVzlX5LBNxmNs+RHnIv
+KNdW3jDKObH6nt6eJUBcxZrutLpcDMgC7X0x4YU558WuffR0ncdNf5JPDeBrhUd
x0WD+1Yq4vbbl3ZI/BfNx4YNTZ7hW8S3GtvH752TGLafyDBl7I5h3x610SpmHIPB
nYcMcZEDco4AB2NWRI44
=j/fK
-----END PGP SIGNATURE-----

--dP17qLfgq3afTBmP--
