Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3G3OeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:34:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3G3Od7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:33:59 -0400
Date: Tue, 30 Jul 2013 17:33:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx
 platform
Message-ID: <20130730143339.GM28162@radagast>
Reply-To: <balbi@ti.com>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
 <1374237277-17769-3-git-send-email-george.cherian@ti.com>
 <20130729151754.GB827@linutronix.de>
 <51F74CEC.8040407@ti.com>
 <51F77F15.7090306@linutronix.de>
 <51F7CCB7.4040305@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mkHYMT4O8DyWoHkb"
Content-Disposition: inline
In-Reply-To: <51F7CCB7.4040305@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mkHYMT4O8DyWoHkb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 07:54:55PM +0530, George Cherian wrote:
> On 7/30/2013 2:23 PM, Sebastian Andrzej Siewior wrote:
> >On 07/30/2013 07:19 AM, George Cherian wrote:
> >>>So from what I see now, it is most likely the easiest thing to just add
> >>>that wakeup to the phy driver I posted. Do you agree?
> >>The whole idea of writing a seperate phy driver was to use the generic
> >>phy framework
> >>and most of the amxxxx devices have the same phy (eg am335x, am437x).
> >>Now since the register is shared in am335x for phy_wkup (Not in the case
> >>of am437x)
> >>how are you planning to  map it. I feel if omap_control_usb can delegate
> >>the writes
> >>to phy_wkup, phy_on and phy_off, it makes the life simpler.
> >that omap-control driver looks a little strange. It has a compatible
> >field saying ti,omap-control-usb and then it requires additionally a
> >ti,type property which should have been avoided.
>=20
> ti,type property is to differentiate between usb2 and usb3 phy for a
> single soc.
> for eg: OMAP5 has both usb2 and usb3 phy

let's try not to add any new TI-specific DT bindings, can you figure
that out by reading some revision register ? Or perhaps by using
different compatible strings ?

--=20
balbi

--mkHYMT4O8DyWoHkb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR987DAAoJEIaOsuA1yqRE31UP/1hqCHmPWSh7Uu/t/mp/K3vs
u4MaavsrJ8+0FhvzuzkqzhWX1Tk9ZlJ+T6srtm/be1LbQ4SF3e+qQB9WYnlBUsgQ
ucEcgDz/28qzgBE3leHK5uO+wIg/M9qeVIXneXG4Eu7S6mb+cqps9M0vmslY1Aiy
cZyK3an9hRTRid1heRG5AOGByKUwcQ3W6QVi5dF/xYPKtWqWNBNgH9BIfeYPw7+Q
QagKa0zTP+QOjKGzxIEqpF3jSKNuAG/51IxCcrPON7WM5/BK/0VM+0SICgHbSjs1
AvO7rra4sgVfa1RkK8uHmpQpUHo30xvNYxanotnrnw6qWuc4l5zjwlSl+cOUSPnk
MPRa7Q51M59R/iKEA/uV18YzK3stVaA6mgEWduqOObLIZm28u2LtB90jZL7x3GLO
zX7DCIcysM9gxKbMt9gLoj4bnQ7+DF9pJMfS1mS8ZOSJlXntEjqVojNW8BQ1henF
EbBvuPLAItZ1gwPvT6yHMSKZDU76B6Uty7PqrPIMYEFAETMeTmpfGYVnVGtc5Rob
ENnk323EDnxJz/q8zhzTSUj3SyAwUiqqGAgHQ6jAFIto4ZaBqq51TZoVWzrDPYn/
LH2NgRF6E9nMWIcaTcRVol95KCklbbH/9Iv0x/bsFflQB0oBJrA/RD19+qTydMFd
V3t8GTRiit6k2gR5lmyw
=0xF8
-----END PGP SIGNATURE-----

--mkHYMT4O8DyWoHkb--
