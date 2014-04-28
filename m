Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaD1TMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:12:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34581 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaD1TMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:12:09 -0400
Date: Mon, 28 Apr 2014 12:54:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v8 02/20] usb: phy: msm: Remove __init macro from driver
 probe method
Message-ID: <20140428175443.GT30292@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
 <1398692063-11372-3-git-send-email-iivanov@mm-sol.com>
 <535E893B.7050609@cogentembedded.com>
 <20140428170357.GP30292@saruman.home>
 <1398707568.23146.0.camel@violet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dBMBt2YGaTHbdllf"
Content-Disposition: inline
In-Reply-To: <1398707568.23146.0.camel@violet>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dBMBt2YGaTHbdllf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 08:52:48PM +0300, Ivan T. Ivanov wrote:
> On Mon, 2014-04-28 at 12:03 -0500, Felipe Balbi wrote:
> > On Mon, Apr 28, 2014 at 09:00:43PM +0400, Sergei Shtylyov wrote:
> > > Hello.
> > >=20
> > > On 04/28/2014 05:34 PM, Ivan T. Ivanov wrote:
> > >=20
> > > >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >=20
> > > >This fixes following:
> > >=20
> > > >WARNING: drivers/usb/phy/built-in.o(.data+0x68): Section mismatch in=
 reference from the variable msm_otg_driver to the function .init.text:msm_=
otg_probe()
> > > >The variable msm_otg_driver references
> > > >the function __init msm_otg_probe()
> > >=20
> > >    Hm, this warning shouldn't occur before patch #4, no?
> >=20
> > good catch, this could probably be merged there.
>=20
> True. Should I resend it?

hold on, that's simple enough to sort out while applying. Unless there
are any other big comments with your series, no need to resend.

cheers

--=20
balbi

--dBMBt2YGaTHbdllf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXpXjAAoJEIaOsuA1yqRE0ewP/3c6SZOPiBcn5ypibisudBTM
idLw7lcbi7cdI27vxDQAG/Ed4dIr5LasCey7Sdt3QcNUK1dTkAS5QjRY2Oof5oms
XP+5bQJz4e7Q8j/x+U/gK0eWDvv4b5lnUBH4/oDQgZwvYEo0l5hkP4lEy1Cx8Vmx
sBqTNi/ErEpJPEqYQoTQ5u350v0Tz8Kbo+yperKTZmZ4TReF0TIqCTKm0bQRkL2o
HWbYcJPjs+L/GXATGEBpNCANNznoF+0t6eOBthefTVZEVXXH6xhN7z0Ih7l4e41Q
Ku6pBXgV3aTnbqI9zPuL/MGFGVgkpNMFE2cd25X1Qyqm7ZhgBtPc0HJe8SjFrXo9
UhYE5fVVBIP5QTiIS2heZp4OMR6vfNNfZQU7QFBvJgf/Nc9SePI9YkUDUnNpvMlH
fMml8M82QE3k4eVpIv6ngIO7BuXE2zF9g2btjRuBEaXgutKwxob7fyDRWA3o1Q+Z
IgQq6vZaPEkiCPnypJGl/PLCcFSo15QFajHVG9ycIZecxKnwPUKJkTDIem9JJN5g
Tw6J4tQ3JQ6skD8jzEJqShcwPiMb2Lyep1zgdGFMB9AVicHq4lLN08fPiOxuSmGi
5axi54nhqOObZbUxp/IHLXDUtDGaFI6mSReoMGATKYqoyxNKTj12RPLO9XJh+edz
qhsaBL4fuUOy1ceirDoV
=lhrl
-----END PGP SIGNATURE-----

--dBMBt2YGaTHbdllf--
