Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161933AbaKNVNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:13:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaKNVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:13:46 -0500
Date: Fri, 14 Nov 2014 15:13:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <sebastian.hesselbarth@gmail.com>,
        <Peter.Chen@freescale.com>, <p.zabel@pengutronix.de>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 08/13] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20141114211334.GF16388@saruman>
Reply-To: <balbi@ti.com>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-9-git-send-email-antoine.tenart@free-electrons.com>
 <20141114210832.GE16388@saruman>
 <20141114211052.GA8105@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <20141114211052.GA8105@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 10:10:52PM +0100, Antoine Tenart wrote:
> Felipe,
>=20
> On Fri, Nov 14, 2014 at 03:08:32PM -0600, Felipe Balbi wrote:
> > On Fri, Nov 14, 2014 at 04:25:58PM +0100, Antoine Tenart wrote:
> > > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > > specific functions.
> > >=20
> > > Tested on the Marvell Berlin SoCs USB controllers.
> > >=20
> > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > ---
> > >  drivers/usb/chipidea/Makefile       |   1 +
> > >  drivers/usb/chipidea/ci_hdrc_usb2.c | 117 ++++++++++++++++++++++++++=
++++++++++
> > >  2 files changed, 118 insertions(+)
> > >  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
> > >=20
> > > diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Mak=
efile
> > > index 2f099c7df7b5..1fc86a2ca22d 100644
> > > --- a/drivers/usb/chipidea/Makefile
> > > +++ b/drivers/usb/chipidea/Makefile
> > > @@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+=3D otg_fsm.o
> > > =20
> > >  # Glue/Bridge layers go here
> > > =20
> > > +obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci_hdrc_usb2.o
> >=20
> > usb2 is too generic, you should call it ci_hdcr_marvell, or something
> > like that.
>=20
> This driver is generic, and not only for Marvell Berlin SoCs. It is part
> of the Berlin USB series as it is the first SoC to use it but Xilinx can
> also use it for example.

then how about ci_hdrc_generic.c ?

--=20
balbi

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZnB+AAoJEIaOsuA1yqREo/MQAKT0TREvPaCA2TaBA1KduXLp
nZqWKVFa0AP9EE1cHW09tIbaPxhEnmfBI2/oS05/fYUmEZ4AMKIxf+dleFoqRI70
wa0gmrtHZysOu3NpeGDvkgTepLf7lih7EcZuJmlantBY/ZUKPhyuECNVxMiuozb2
c7jZi1Fjykg/cNy1iemgx8q0vPTvyMWgdNGp0zIakYJV+K8uj7BQh/bsiWiWyfLS
ztZCSWqkPVNFcUtE0RdJb2l34tQ/60jFLCfNRBCRoxn3gp5k4qaNyb2/JkEGGelA
AaAe8s4ZTklejX0Tom4+NoeHC9RCoammKKnXL6jnDLgpBEHxp5/shT4SePFIwwg9
xHz6etaJMAIop/PUkKYIuMXq/W4wA9KZBnQAxQ6hLOocHpf0k9sVbdanoofyvMeo
nSHff4Lf0dtn0U2he9MnUIAhCqxxq5YKSsk9vx+aVFmMlmLN5WQm3K4HDdcIWyVO
Vnv2jrrLF49GT4oda7cPWB7Cr2PNUuF8auSFznOgoFyr6GqFqUEU0FIt20jXodkX
PcwgzclSrQvfhDsge6f3sGp0DLqUqamUHQYDPmmz4gAlGj4czv5CRYuRL169vKbm
7o2llS0ko9YY4b2GKTw4SpOT3u6ufHzMiQfpMFiVMqcRyzCYQn+aXm+RMdNIv6SR
LQscvoRc5RGFLagBLE5Y
=atk8
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
