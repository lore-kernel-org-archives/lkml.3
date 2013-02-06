Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3BFLWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:22:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50908 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3BFLWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:22:43 -0500
Date: Wed, 6 Feb 2013 13:22:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <b-cousson@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5] ARM: OMAP2: MUSB: Specify omap4 has mailbox
Message-ID: <20130206112231.GI22064@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360130294-5976-1-git-send-email-kishon@ti.com>
 <1360130294-5976-4-git-send-email-kishon@ti.com>
 <20130206105713.GF17852@n2100.arm.linux.org.uk>
 <20130206110355.GH22064@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nO3oAMapP4dBpMZi"
Content-Disposition: inline
In-Reply-To: <20130206110355.GH22064@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nO3oAMapP4dBpMZi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, Feb 06, 2013 at 01:03:55PM +0200, Felipe Balbi wrote:
> Hi,
>=20
> On Wed, Feb 06, 2013 at 10:57:13AM +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 06, 2013 at 11:28:11AM +0530, Kishon Vijay Abraham I wrote:
> > > Added has_mailbox to the musb platform data to specify that omap uses
> > > an external mailbox (in control module) to communicate with the musb
> > > core during device connect and disconnect.
> >=20
> > So, I've been through your five patches looking for any other users of
> > "has_mailbox" and I can find none.  You introduce this in this patch,
> > and you set it.  But I don't see anything that uses it.
> >=20
> > Write only variables are not useful.
>=20
> looking back at what I sent Greg this was probably my fault. When taking
> Kishon's patches (in particular $SUBJECT) I removed some of arch/arm/
> code and ended up forgetting to add the include file which introduces
> has_mailbox.
>=20
> This means that my lack of attention has introduced a compile break on
> Greg's tree. Oh well, s**t happens. In any case, the user is already in
> Greg's tree and there's no way Greg will rebase his tree to amend
> $SUBJECT there, so it will have to go separately.
>=20
> I didn't even notice this before because I had the diff in my tree, just
> forgot to git add and/or git reset. Too late now

there's a little more to it. When running allmodconfig,
CONFIG_ARCH_MULTIPLATFORM is set but none of the other ARCHes
(ARCH_OMAP, ARCH_AT91, ARCH_VERSATILE, etc) are set, so it turned out
that the driver wasn't even included on my build test.

Russell, is this expected (the MULTIPLATFORM thing) ? Just so I fix my
build test scripts to use another defconfig instead of allmod and
allyes.

cheers

--=20
balbi

--nO3oAMapP4dBpMZi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREjz3AAoJEIaOsuA1yqREfKIP/jGwTIp/QaLQsQN9iM84EewQ
sONWR5uWZvZcHL5YcPTofiaZWWO5JsBsH3b7MtMMINdtPN+v3c2TuI+6UepVyo91
8UilkZK5MFikH5t7gGfAabocA0Wjoehuk1JV4PRMUx5C6YuHcX2p1RyVBgZnBjQj
CEsypqpSeme2LACyud4+8UKPrH5sNGocF2lekfGMkMEAUqigtM0hU+9rQrB0D8td
9if8jMw8Zj8qqzGcIYo/p8otilNmltTfMG+AQUYD6NxCnfv5wDBjelbzFN+lUKVS
C+WpRBanX5rC2cG+zZJJgLV0e8vwMWVZb5cCZzjVMf2dZ5NIrQa6srC1nk1tQoLh
Pjv+LnWRpGSc5s1Z9ZUeyohYV3RffUp+dsmjncLzZFDdywTMA0XMZNNyJypWcZsf
UkZ+ZunQ57A8u2m7PgARgnFbavJcacX7/WwmdNRnY2O+CUK5dzTerhkTLF4rG7qE
L2Cnn+9rLlJ+CZF58yx0wd4mgEaVfF4GE3uozbd3fXWRr2KxwmivKYoTwDbns6ah
OQFvMoYt9t5envwHc+7bWvNCuRtfYomKx86UW0qRn9gotM8RpVhLuVipjsmM7QTU
vm7OdyKrtvq25Z+WZcfaqFIICAZ4olwK0Ek1YpPAY2Q3pcj+Xh8pOttKjCplvAdC
XRgJlkMweggNMimfY6Zt
=M7IW
-----END PGP SIGNATURE-----

--nO3oAMapP4dBpMZi--
