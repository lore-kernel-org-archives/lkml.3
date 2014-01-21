Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaAUVeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:34:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57757 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaAUVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:34:19 -0500
Date: Tue, 21 Jan 2014 21:33:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org
Message-ID: <20140121213359.GA17314@sirena.org.uk>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-68-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lJ4sC/874/3I/gBU"
Content-Disposition: inline
In-Reply-To: <1390339396-3479-68-git-send-email-paul.gortmaker@windriver.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 67/73] drivers/base: delete non-required instances of
 include <linux/init.h>
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lJ4sC/874/3I/gBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2014 at 04:23:10PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.

Acked-by: Mark Brown <broonie@linaro.org>

--lJ4sC/874/3I/gBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3ufEAAoJELSic+t+oim9EbUP/04oCqKsId3MbalwT055aJDW
PMtVkQ5U76QjrGGRiNPuv4KSVr1pwNtNIK3ExIRinVtcfeIekzrnLfSJ+0WloLDb
lCmZx4SwnrQP106qr255yjoL1veKCkjgdn7C01Wmv9MOSuwPFlqYsG2pSPQzIVsA
nxmbhJpQ0GlmqIFCoZz+JCrlzodemqJ2j83iiObOWgPC76DPtpZegOQA+Bb+n84N
TaDWJTaRN6wIyCSxQ8OnSqPvDF367hIkM8KiCu6pifNOOJZjZUNEmpHZSmEM3SUu
Z97fFqDoUm9NE798ZKHzHgEpEufDMA8vIaEUS/BFbwkj2u3t+Iqf2JnE7OiPait2
EpOG9TYFgwDQM1PNWQ6s0GH7tQg5DYPyXd4t7WgEXg1AnbmtLKHRa8TvMQy0cklW
MNdSIB61wQJcjRAWg41+dsUoz6jokIQ8iJ2WqvfnBI/Yt/TIFjaHBOxBtNSL9Kl6
q9kaOJfkQ6pD6B/FZmfulU6GU739sdRgVTXDuAKcJE1HQSwF+jdlGHlEeQEI4iuU
txfsR6gbgIxr85Pu6wL+s2cMSskKDrJCc/BHWo2u2eM2JB1zMKbh8dj9ZFeO8Lcm
VnySV6cvfBwXkR5pD+hJb61NvkGS3vDZRWqR8dP8Tadgru7xqNSOg3ex1ZFsCCAL
Z0V+GL8LKsx21lVGHsYy
=z0oX
-----END PGP SIGNATURE-----

--lJ4sC/874/3I/gBU--
