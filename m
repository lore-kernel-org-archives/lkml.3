Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3BFLER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:04:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160Ab3BFLEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:04:09 -0500
Date: Wed, 6 Feb 2013 13:03:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <b-cousson@ti.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5] ARM: OMAP2: MUSB: Specify omap4 has mailbox
Message-ID: <20130206110355.GH22064@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360130294-5976-1-git-send-email-kishon@ti.com>
 <1360130294-5976-4-git-send-email-kishon@ti.com>
 <20130206105713.GF17852@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82evfD9Ogz2JrdWZ"
Content-Disposition: inline
In-Reply-To: <20130206105713.GF17852@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82evfD9Ogz2JrdWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 06, 2013 at 10:57:13AM +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 06, 2013 at 11:28:11AM +0530, Kishon Vijay Abraham I wrote:
> > Added has_mailbox to the musb platform data to specify that omap uses
> > an external mailbox (in control module) to communicate with the musb
> > core during device connect and disconnect.
>=20
> So, I've been through your five patches looking for any other users of
> "has_mailbox" and I can find none.  You introduce this in this patch,
> and you set it.  But I don't see anything that uses it.
>=20
> Write only variables are not useful.

looking back at what I sent Greg this was probably my fault. When taking
Kishon's patches (in particular $SUBJECT) I removed some of arch/arm/
code and ended up forgetting to add the include file which introduces
has_mailbox.

This means that my lack of attention has introduced a compile break on
Greg's tree. Oh well, s**t happens. In any case, the user is already in
Greg's tree and there's no way Greg will rebase his tree to amend
$SUBJECT there, so it will have to go separately.

I didn't even notice this before because I had the diff in my tree, just
forgot to git add and/or git reset. Too late now

--=20
balbi

--82evfD9Ogz2JrdWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREjibAAoJEIaOsuA1yqREA0oP/R2MWF3hea5B7ai98C4pb3Jp
+maAACPF6IxGXoChq7wBEPHPK8ZsLa3Ca+8/rxgUaECcpYqXsprDf9SUowUtMBs9
LOyBBT+OPGvnHPD2YsLhp+6HgmHKZRhwXEsl9hxr4s2ZlBORy7+6BR49WnV5yYtK
SJhvT/bOhs9uENJWmSolw3XB0KcODWVmp3P9jankDj7FoqNGDmsyHZysW0s4jEGs
Jai4GZOS4+EqAiODiByI5RrgmD95mUT/KTRdJTN0tP1q0/PQjPFAPfJcB9x+NtjX
mAOOwU9MvOHUdjcSxFMMt4XeMjyhE6AxIIvm6NHL1oq6wvUbMqMiYSzTdE/WZlEL
bh8rd9H0shRhF3N0LW4FJpooiwGd9v9GhbpHVn2lHJNx5pgWrS6eyO4PewDAyEF/
vc4ltprY75/EMqkD7qP+jFJiQtC5FeHJMP6qKLEfZAWp5Yp/ezbLpK5WdOOx1GoI
Xk6JSR+TqKZeqXnk97bzuOuYIr/m/vK7I2Fi+k2o0cdlaltJZjAvhmLA2+N723z6
F8vFNTjURiKmrajxMSGs9PbVvtmsgdDw5SiA/VtZgM/8cp0+hKp4Yo5h/jJrgW6P
LhXviYAEs4VCIj1dEojOVqAq4E4GuTcYDAn6bndC1uOoEyWWfFp3/WFF6IOzN7NG
6C0T54VwBGCx6PdWxnqT
=+GVp
-----END PGP SIGNATURE-----

--82evfD9Ogz2JrdWZ--
