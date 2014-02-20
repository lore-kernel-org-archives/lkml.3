Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBTCth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:49:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57572 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBTCtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:49:33 -0500
Date: Thu, 20 Feb 2014 11:41:47 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20140220024147.GT2669@sirena.org.uk>
References: <1392857410-9068-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VTQWGtSAzbj4ETFu"
Content-Disposition: inline
In-Reply-To: <1392857410-9068-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.224.205
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH Resend] regmap: fix _regmap_update_bits()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VTQWGtSAzbj4ETFu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 08:50:10AM +0800, Xiubo Li wrote:

> This resend version just rewrites the commit comment.

I've applied this but I updated the commit log further - part of the
reason this didn't get applied first time around was that it says it's a
fix but it's actually a coding style change.  The other part of the
reason was that at first glance I wasn't sure if it was actually an
improvement so wanted to think about it.

--VTQWGtSAzbj4ETFu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBWtoAAoJELSic+t+oim9dxQP/3OFiAJELO3YnpWxVPXP6qRo
5WmzPJmB1x5QRcJn/OZ28QbmOOIUtoM2G2W7KU0gVmlHPvTm+CEeUAM4WdKq+cOV
ez0DfhEU+6FTlaTgGx/14kxkyDcywk2ZYyiihazfkK3fNLyUOi6jrM4i0whTuAqA
y62ZWub/XVwvgZQKtcuakZ+HpGtARDBrqR0bjyMOt1Unuu0jb2L3wqjEeNTmdPug
uRNXPyx82RW56VtWjNZvI41XHG28DmAa5jRgkh45/lyD4muJoh68Ip69iipqRicI
nDp7rB/ycK19CbtKNRzqds+Ag4KdeJp01bJO7+MzQT2ORu+fOi9F9lkSdzpOzZAV
L0xX5BMRzQZRVCODa74aiNN1BJLHyDPIOeFVOGuVJdXiGTceHb65TMfLKSnRDK3T
Cs0gwmS5SMl7lUtrpitMKpo4bo/5zw4g9617SJ+xvl3wVFahKnJq2wkASHTVMn58
3uUNIcJI/3N8L+kc/s8/QhUZOqw6Thyzo9zPa/U8N5RYRVdSb5O/GN0J0vDdiFng
GAI8uhClD5O4JG+3qulwR4+b+WqR1L6XcXXR7AmAsW1TyxER3Mm7b+V4eD+WWIdp
M5gLjkx7VmLxr3fAnirgiYVMy9SZJg/+yCec0LtdBk3retNRyYg2wBWo7E+f+zyM
7AD7Lh06PzBrTcRqrD8E
=gmaz
-----END PGP SIGNATURE-----

--VTQWGtSAzbj4ETFu--
