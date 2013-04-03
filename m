Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878Ab3DCMWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:22:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36169 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643Ab3DCMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:22:11 -0400
Date: Wed, 3 Apr 2013 15:21:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Florian Fainelli <florian@openwrt.org>
CC: <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
Message-ID: <20130403122150.GZ25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1304021359130.1314-100000@iolanthe.rowland.org>
 <515C1C61.50301@openwrt.org>
 <20130403121503.GY25837@arwen.pp.htv.fi>
 <515C1E0C.4070306@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6JAe/4X0qssghT2u"
Content-Disposition: inline
In-Reply-To: <515C1E0C.4070306@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6JAe/4X0qssghT2u
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 02:18:20PM +0200, Florian Fainelli wrote:
> Le 04/03/13 14:15, Felipe Balbi a =E9crit :
> >On Wed, Apr 03, 2013 at 02:11:13PM +0200, Florian Fainelli wrote:
> >>Le 04/02/13 20:06, Alan Stern a =E9crit :
> >>>On Tue, 2 Apr 2013, Florian Fainelli wrote:
> >>>
> >>>>This patch removes the depends on USB from all config symbols in
> >>>>drivers/usb/host/Kconfig and replace that with an if USB / endif block
> >>>>as suggested by Alan Stern. Some source ... Kconfig lines have been
> >>>>shuffled around to permit a better regroupment of the Kconfig files
> >>>>depending on "config USB" item. No functionnal change is introduced.
> >>>
> >>>This looks almost right.  The only problem I see is in
> >>>drivers/usb/core/Kconfig.  The USB_OTG_WHITELIST and
> >>>USB_OTG_BLACKLIST_HUB symbols don't have to depend on USB or USB_OTG,
> >>>because they can be set if EXPERT is enabled.
> >>>
> >>>To avoid these issues, I think the best approach is to move all the
> >>>USB_OTG* entries over to drivers/usb/otg/Kconfig, where by rights they
> >>>should have been all along.
> >>>
> >>>Felipe, do you agree?
> >>
> >>Make sense, I will make this a sixth patch to this serie if this
> >>sounds right with you?
> >
> >Pleae don't. Look at my 'next' branch. I deleted drivers/usb/otg/
> >completely. OTG should be part of usbcore and I have plans of adding
> >generic (and optional) OTG hooks in there.
>=20
> Ok, then I will leave it as it is now and simply address the comment
> your made initially, does that fit both you and Alan? Thanks!

Fine by me, if something else needs to go, then we can tackle it during
-rc or for v3.11.

--=20
balbi

--6JAe/4X0qssghT2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXB7eAAoJEIaOsuA1yqRECboP/AiFom6B/6WgDPwvPch/1ZDG
/S5tNF7Yq9PJt9Tl06AqQU3Srm8E923+wtJUQ9WUQr8tKFycJryi+9NeJA5CgW+g
zuEYXywz4fn2wLzHoSir1+anS2rEPs/1bwPsyEKGSGLmK1M3NJqvQSLX3VbhhNgi
k8FysKgBXl6yjc+Em5B0io7hF3iFCLzCfKsmcm52L1ZQxFHjMjiWXz2PajdC8+Qu
lJtVemGnRCgTLZoQYFeT0rbOlItT2hE5wg3hXjYfSeru10TU8z98NFSUMPoNnO7v
71voyxC7vlP9xZLEQBmCOYyQk+NNBg8DoQHQu3NTEFZUrAE3FtQZAB8/maxiO/w+
QLU9JlhzEx3WmoRHOkIZPiKeWpN8bqR1HD95wrPhzSGr/YJsgGuSN3WzFwm53mDW
//83aZ5O1xskkfm/sfQhey7RQg1eKSBKYzfjTeNcgKoQK9p+9CF9HCwqK6N3GRaG
s4dMTkYZ+V/tOXSf1CuHk8unI50WBNwXuX6TvopxZEFy7ViM7U31QSxIboNT/c+o
1J8n096uEw8oHcY372LRPWwlQfgOq4MHJOmAu9FqtXrJaGhL3u9RWaKQNVrVwwZW
PqhpyuGKJzFVli/7h7h0z2DzDI3tiDbUfx+iUSuDeVAmy8DuyiB1otUxfUwaafZ3
OvWb4Ia4wHuiI4puEXkD
=MHO5
-----END PGP SIGNATURE-----

--6JAe/4X0qssghT2u--
