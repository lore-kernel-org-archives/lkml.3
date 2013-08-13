Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab3HMTwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:52:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55106 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3HMTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:52:00 -0400
Date: Tue, 13 Aug 2013 14:51:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (usb-gadget tree related)
Message-ID: <20130813195133.GC11075@radagast>
Reply-To: <balbi@ti.com>
References: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
 <20130813194803.GA11075@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <20130813194803.GA11075@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 02:48:03PM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Aug 13, 2013 at 06:17:19PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (powerpc allyesc=
onfig)
> > failed like this:
> >=20
> > drivers/usb/phy/phy-am335x-control.c: In function 'am335x_control_usb_p=
robe':
> > drivers/usb/phy/phy-am335x-control.c:117:2: error: implicit declaration=
 of function 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
> >   if (IS_ERR(ctrl_usb->phy_reg))
> >   ^
> > drivers/usb/phy/phy-am335x-control.c:118:3: error: implicit declaration=
 of function 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
> >    return PTR_ERR(ctrl_usb->phy_reg);
> >    ^
> >=20
> > Caused by commit 3bb869c8b3f1 ("usb: phy: Add AM335x PHY driver") from
> > the usb-gadget tree.  Forgot to include linux/err.h.
> >=20
> > I have reverted that commit for today.
>=20
> damn, I didn't catch that. Sebastian, can you send a patch ?

nevermind already patched it myself.

--=20
balbi

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCo5FAAoJEIaOsuA1yqREYOMP/1bsr78BMp/kdGiceaCz3IsB
gUCAZulqRdszpffVVtK5Kip+5ukzNhoJ8zvH9aydU8lhVj1mrlshVS9N4Augsyqr
6s7A4Aic9f77iEzNaMucUdnlzuSBbxCq9V/bieW2T+ourKZPzUoTHSPGD5qwoA9K
uvG3SEEeLK0sJNWJbt57xsuObWNs00myQVa6Mpmmh3VKdLrbayKED6FvcyEFbt/5
bxQGXLD7LAMV6n+Ns94CagPimk2oCXGRpCBnZHECR2JDK7hKpqUUZWWsYkemSEu8
kkSRohnkva9xhYDfPclDDcIiIfxmyG0JAmwwUcVy68DytEYt/QIjN7QsjO9mWKlL
cDiss3iwO8fadWlNpS70/JNaCOZGPH1Siz2Lpd1meNdmTPnnU1xxS0RMeY73mX/s
kCicTrYxwu69ZxcMX4IU8aifs9oPf7+0z9zOOLW5LAZmbsRdNUzxey/Q4CAi8lkL
8nWSpZVcqXhCcSXbOMIXXhbnJ0r30ney4aaswjRgaZr1NhqzwNErtdWMSlI4VRn9
J0Y3AqmewSBVzAmVbOucosS909RyJsKIErqG3IuBbOqXFIOlZcikWMZo+bYwfd8K
WneipdzXC1gMbJv7aE84KkYKydS3QPOANWxlzDZzK4B74tETFC07uMKMw8TAVlxV
OGVuu1vjLMstfKK+y7Js
=Ixgj
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
