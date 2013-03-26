Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3CZKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:20:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37766 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab3CZKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:20:29 -0400
Date: Tue, 26 Mar 2013 12:19:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, "balbi@ti.com" <balbi@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
Message-ID: <20130326101947.GC11244@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1364203926-24488-1-git-send-email-kishon@ti.com>
 <51501CFB.4020905@nvidia.com>
 <51513A40.7080905@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <51513A40.7080905@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 26, 2013 at 11:33:44AM +0530, Kishon Vijay Abraham I wrote:
> >>+static int palmas_usb_write(struct palmas *palmas, unsigned int reg,
> >>+               unsigned int data)
> >>+{
> >>+       unsigned int addr;
> >>+       int slave;
> >>+
> >>+       slave =3D PALMAS_BASE_TO_SLAVE(PALMAS_USB_OTG_BASE);
> >>+       addr =3D PALMAS_BASE_TO_REG(PALMAS_USB_OTG_BASE, reg);
> >>+
> >>+       return regmap_write(palmas->regmap[slave], addr, data);
> >
> >Same as above.
> >
> >
> >
> >>+
> >>+       if (status !=3D OMAP_DWC3_UNKNOWN) {
> >>+               palmas_usb->linkstat =3D status;
> >>+               palmas_usb->mailboxstat =3D dwc3_omap_mailbox(status);
> >Omap specific call, why? This is generic palma driver.
>=20
> hmm.. I think we should either fall-back to the notification
> mechanism or have the client drivers pass function pointer here.
> Felipe?

hmmm, if palmas is being used outside of OMAP world, then I guess extcon
is the way to go... too bad

--=20
balbi

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUXZDAAoJEIaOsuA1yqREQY8P/0zgoJwWFv5JtSuAG5DvauyV
qvU946hZNuvXO9UqjUoOzTWt/pJ2Xgs6KltKlWMjcEms5CXmnkcz5tl2FxLATkVY
1DIR++59tjbe082DJZ62jq42WrwS4+1nKomUL/8ryq5EbyULniuAy4v7UEwU4sMC
9988CtTJUqhoiHew6ykC1rhh9gHictOGs9zt5/vl310pnjb3far1MNq2RIu9G/57
Q/AZ0repWHC7D5bVVcayu/FuqAtbyBqx3NIdXsSJSLJ+mMjkrX9GtTuZLTV6msp9
LjpYjonCDFvsf4L+lxtqWh+7mq8jkjU+h9Yp4tkCpUQG7LwDLhjfviRiJJPsGakt
AJiqIaK+j14FvumVBfdpzw/w1WbNUhwujnUPQD/fCU1sjLssErjemN8oByHwV1At
Sk6i/7tS2BOhAdPU+fwibduI4pFrSLWvYGt3JGdHGHM3I7TuCFLGqgM6tXyNgap0
ylLdDauKsZNF0uSGuFwNRIa9Kh3jt0oMnGQptfxWmMKXNhkZME/drT+t7IMZPvXq
W8gXdPom4dUX5/7s9BCrILlD0dB23raVxxKLb0ccBhVE9/W3ay7T2iVQ1sYhhAtt
Ij0GniMWKzKgoBm4WtDlHFwLPy87yk4dKhA+NBKe2ZmQx9X+jwKaFmSQ1/Y7o0B8
FBOpOtguEgIGMwyJy6Nm
=qWKv
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
