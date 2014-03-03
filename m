Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaCCQno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:43:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33768 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbaCCQnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:43:42 -0500
Date: Mon, 3 Mar 2014 10:41:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
Message-ID: <20140303164129.GC10987@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com>
 <20140303163308.GA10987@saruman.home>
 <5314B019.9040505@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <5314B019.9040505@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 05:38:49PM +0100, Gregory CLEMENT wrote:
> On 03/03/2014 17:33, Felipe Balbi wrote:
> > On Fri, Feb 28, 2014 at 03:34:01PM +0100, Gregory CLEMENT wrote:
> >> The debug trace in the atmel_usba_stop function made the assumption
> >> that the driver pointer passed in parameter was not NULL. Since the
> >> commit "usb: gadget: udc-core: fix a regression during gadget driver
> >> unbinding", it was no more always true. This lead to a kernel crash.
> >>
> >> This commit now use the driver pointer stored in udc which fixes this
> >> issue.
> >>
> >> Since the commit which have triggered this issue was backported to the
> >> 3.2 stable branch, then this one should also be backported to the same
> >> kernel.
> >>
> >> Cc: stable@vger.kernel.org # v3.2+
> >> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during ga=
dget driver unbinding)
> >=20
> > this line shouldn't be here and you're missing a SoB line, can't take
> > this patch, sorry.
>=20
> Right, I forgot the -s option for this commit.
>=20
> and you want the "Fixes" line be before the Cc: line, right?

right, that should do it.

cheers

--=20
balbi

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFLC4AAoJEIaOsuA1yqREq7AP/iIY1B9kMG31N9RDR3qp80f/
d7PgKLHJCa9j+1RRmTnnI846+Yl2XpQ+EIWkvaXDSi+l0DoKSkTLqNYuPCzWHlmN
QcvSYfqSQvjXEwtoQ1VWDS0NYS3IT7Z8h1M4XnwWPps8UzQUlKe0A6vejKaJ+iIs
eypG9QwgRlnUGgDH2HRhzkAD03BNGAt+C1AgwyUWws/0V1SLdLwaGOOCL62+A5Zq
zbn1Immb/GLkNGnwYGj2eCnfVGdg0xFr3GEWdnZ3RjmPzzIy2a5uj5EXOmUgmIOI
yNMZiL7/VN+os42uaxDwOxBwl7DAXcVxspo26MvXve5YcKpC4suxt4829Z9FsmBC
rjbo7Bdc1X34wUO/6BKnI7o6BTB+aPOm+5Tlf0NKHx3UIcUSk5sHPeDLtCWgvqpt
LSVAp/RJMgQNEvoVOwibKCDifKq9Wy+7b/3znzKC0CWstjoXeLTvpWTBmn4ah9eV
O0/gNXqUY91Q40Hj5faLB5IG/PDLX8fbumoUWG6hxRmcnGcGI5Zk4WOxmcncsW1X
z4SZwqkyOMMzxNZINBk+I9Hut9P0vFP6yJAGh6nlgFx+LdKii/+EwNmoHQbrex3t
Nke18eWGKWpqYo/ATJHADAkVlleX6tQzsgJxzZNgeI9O6mQK3oJZ71zdpSwzw80f
ecSKNAjsGJHK4nyp7Dez
=3Tfl
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
