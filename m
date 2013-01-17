Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3AQWcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:32:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49727 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3AQWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:32:31 -0500
Date: Fri, 18 Jan 2013 00:32:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Tony Lindgren <tony@atomide.com>, <sameo@linux.intel.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
Message-ID: <20130117223206.GA28533@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-20-git-send-email-rogerq@ti.com>
 <20130117170321.GJ14149@atomide.com>
 <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com>
 <20130117210034.GA27671@arwen.pp.htv.fi>
 <alpine.DEB.2.00.1301172228140.14118@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301172228140.14118@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 10:29:52PM +0000, Paul Walmsley wrote:
> On Thu, 17 Jan 2013, Felipe Balbi wrote:
>=20
> > do you mean v3.9 ?
>=20
> It sounds like the other patches need to be merged first before these=20
> cleanups can be merged.  So rather than adding a merge order dependency=
=20
> during 3.9, it seems best to queue the non-essential clock cleanup side=
=20
> for 3.10.

got it

--=20
balbi

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+HvmAAoJEIaOsuA1yqRE5h8P/0CiIx6RZeiUQDyin+ho2COh
QcHmS0aMlp6aw0Pb+ejCnwU3pII+VmIGYnwiSrRGFmRsmwYs194L1Beij2tuegcj
uu28GYGZslWsE9oabORu2FkMVKFnL+GymilNrt/IMm9LLG7mZo0qyTxj8u9uOmko
8V7rrRgieJe1lGq0a44ZpKuhhUy5xzuUJa2lH3YOukMsc1+JWvOIKlBFtTxEODBf
dB3psWlkg8iHp338b5+zS5xH7tuMAyvJ7cd93uVY4HzUSHl1LWS5s3vOl14G8Nbb
Khr/+zurnaDfLEW/QhjM7iJZJS4+/tZI7hNiPNyR188OPP8xXoq00C+Qyc9D0ork
q0ThqXLQ/VgJ+fPSzuYcwQIPy8ZUm2iLBN3yjtTdsc4HP2O+OeU/FvOgCZBowX6d
pBE51FHNvgEj/bBhIwZpwIXUoh7sbDVsK9VD+dCr6LKENlMaQ4JGuD8wHzK5Vx9W
bthII1dzGAfyFdQ3l+uv0427vv6zFETGCy1VGBP6sK2EHA1X7LVLaqiyJGlj/Wqp
Pb0T/YRvkRnqgOxm++KXFtNYxs5Il/Phtv/QVoqr6rFwrYFgXgM0Z8IKg6RMiuYJ
KsFxg6zhwBFHJF3VC+tfYisDVn61MKk+iTN1+aCooYsY9QBQHx43LsEGh032fHgo
b3fEzv3dWpibxRRmRJYI
=uMhq
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
