Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3CNOr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:47:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42245 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3CNOrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:47:55 -0400
Date: Thu, 14 Mar 2013 16:47:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH v2 0/4] usb: musb/otg: cleanup and fixes
Message-ID: <20130314144744.GM26080@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
 <20130314133313.GB26080@arwen.pp.htv.fi>
 <5141E26C.10700@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSyhVCl2eeZHT0Rn"
Content-Disposition: inline
In-Reply-To: <5141E26C.10700@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KSyhVCl2eeZHT0Rn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 08:15:00PM +0530, kishon wrote:
> On Thursday 14 March 2013 07:03 PM, Felipe Balbi wrote:
> >On Thu, Mar 14, 2013 at 11:53:55AM +0530, Kishon Vijay Abraham I wrote:
> >>This series has some misc cleanup and fixes. The fix solves the cold
> >>plug issue in omap3 which some have reported. Developed these patches on
> >>fixes-for-v3.9-rc3 after applying
> >>http://www.spinics.net/lists/linux-usb/msg81563.html
> >>(Grazvydas Ignotas patch series)
> >>
> >>Tested for g_zero enumeration in pandaboard and beagleboard in both
> >>cold plug and hot plug case. Any kind of testing for this series is wel=
come.
> >>
> >>Changes from v1:
> >>* removed *usb: musb: omap: remove the check before calling otg_set_vbu=
s*
>=20
> er.. removed *usb: musb: omap: always glue have the correct vbus/id
> status* since a patch similar to it is already merged.

alright, I'll apply this series soonish.

--=20
balbi

--KSyhVCl2eeZHT0Rn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQeMQAAoJEIaOsuA1yqRE2KIP/3WZtZjO/RRDKLh7W0NhQi0Q
mPrDwGEp8TVIOeYqJlTbYARNl2nLcW/bVsGvww4F7VDWPzKLphHT+OyD0EPEg0UY
zQbA91a8hoXobTW5D7fTrSeO4cfzQX4WYecBW6/yJU/x4NyzuUW9ryLUaoHSQLSd
MiqsUDVddcbNkDwnPrDJy9PcyRf4P41zWX5gr6RTPgBoRjlSiwp3/8sHT93Dxhc8
FN8stsIknMYWL0QQK5rUfR7xsodezpH/qkQgWHnsYxHbvi/yeFigSg2iyXpBE+My
GEshnNmP2MM1VZSYRhHoe+DiMacnW4LybwN57uZDH6nAr6gUAWciy2DXSmDrlU3K
TYrKRDnfP3e2AaHxPfJGQy81S60Hl88ZOGRQkk0TeDvPYtHXOLvm+QlbRTGwsr5y
R9pn4RZGprJKH4YVrh2CG2TKkUnSnTvZzenBGzGPteYZry0IcCQrMphSaecRr6jI
QfYYcwx4IrNMNM9XUt4aSpSemf+Zfb8wDymvt1chSJZb3I1AndN7Wl5WSNpkNZe3
YKtYz9V0kM9CP7FHCSO57wvieN1w+yeW3yCpBBuKg1UJszimD1h8tHHOq+zEJlqW
p17rapqng9sd8bBKTPg77+g2ogdeRXirJTSEoFshafOjTj7n2S1q/mMQmNIaDSQi
P5KJhx8VRYOrd7c3wDQJ
=9Ti/
-----END PGP SIGNATURE-----

--KSyhVCl2eeZHT0Rn--
