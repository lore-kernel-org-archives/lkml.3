Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaCDPUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:20:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44972 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbaCDPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:20:29 -0500
Date: Tue, 4 Mar 2014 09:18:50 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: randconfig build error with next-20140304, in
 drivers/usb/dwc3/core.c
Message-ID: <20140304151850.GF15233@saruman.home>
Reply-To: <balbi@ti.com>
References: <CA+r1Zhg3iv4RxC=bWenE+bX=9He6DhfFBXM3L=GOc-Uv=Mxf=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Content-Disposition: inline
In-Reply-To: <CA+r1Zhg3iv4RxC=bWenE+bX=9He6DhfFBXM3L=GOc-Uv=Mxf=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 04, 2014 at 07:30:20AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
>=20
> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
> warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG
> which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME)
>=20
>   LD      init/built-in.o
> drivers/built-in.o: In function `dwc3_setup_scratch_buffers':
> /home/jim/linux/drivers/usb/dwc3/core.c:280: undefined reference to
> `dwc3_send_gadget_generic_command'
> /home/jim/linux/drivers/usb/dwc3/core.c:287: undefined reference to
> `dwc3_send_gadget_generic_command'
> make: *** [vmlinux] Error 1

will fix it now. Damn, I do 200 randconfigs every week and never caught
that, good job ;-)

--=20
balbi

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFe7aAAoJEIaOsuA1yqREKqIP/A4rI8ke0DNp3bpDmVXueQza
BSqakRpmuiawAFbR7twmiyxbWSq1r2VeV8x8d8Z25okxYYlvHmvvsf/xzVq5IQSD
mYpQaI3Yo75QWtlRq17p9I8udzBEAAkKeTmemZUrRMwLVPeBGSk+eTnMQWONPdqS
NZedeyvIQe0Wewcu6rX66ESjfKyXr1ARnNDgI3hI7qio4ZwBq7QGNFrZp8Z5PwUQ
cvG8+qZJxDiK9fxoarJ0xdZQ2oBN/TOXufxpxWqP0lp26YLDsV6NOJbQjJsrhLZP
rz6T1oBTlWFZFgHYTJUYsS6/41dzoHslmnWt+rWHY0KmzcUlanDGo8Y1NTtH9E4N
0831uRFEymYY/+P6brmbmPmR8D/6rkwwncw/mu4iLdpgM0V3XFq/dMWi534h9Ukj
wEVdfoJz/sSnlCME8BVW+Tr6HQLc/ymO9XeMvqOO1a1fXksZurttSfewr1pa9PRG
NT1AggAK0Q04Z6uhJzbxgK9Rr/r6So3JXL+Nj/nYDDO1JVPfnpAY5Enm0NcOw70/
92aUtYqSQd+wik9Xh2F4DzAEmijEbXIO9GGLj1ZROckepG9n2Z3hahKq87jIP/qG
O6sckd6znRtZ4CovcUBP12l/kpnbddcE2zwbhkl/AQKAW/1d4Zwo5HtxF7cFIgKl
BXZRo5yirJYYrpkEiWuv
=Bi0O
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
