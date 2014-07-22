Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaGVOsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:48:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44176 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaGVOsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:48:30 -0400
Date: Tue, 22 Jul 2014 09:47:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 8/9] usb: phy: am335x: call
 usb_gen_phy_init()/usb_gen_phy_shutdown() in am335x_init()/am335x_shutdown()
Message-ID: <20140722144743.GB20588@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
 <20140718135713.GH24914@saruman.home>
 <20140721100307.21172b65@ipc1.ka-ro>
 <20140721151043.GF6852@saruman.home>
 <20140722100613.779a3e11@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20140722100613.779a3e11@ipc1.ka-ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 10:06:13AM +0200, Lothar Wa=DFmann wrote:
> Hi,
>=20
> Felipe Balbi wrote:
> > Hi,,
> >=20
> > On Mon, Jul 21, 2014 at 10:03:07AM +0200, Lothar Wa=DFmann wrote:
> > > Hi,
> > >=20
> > > > On Fri, Jul 18, 2014 at 11:31:29AM +0200, Lothar Wa=DFmann wrote:
> > > > > This patch makes it possible to use the musb driver with HW that
> > > > > requires external regulators or clocks.
> > > >=20
> > > > can you provide an example of such HW ? Are you not using the inter=
nal
> > > > PHYs ?
> > > >=20
> > > The Ka-Ro electronics TX48 module uses the mmc0_clk pin as VBUSEN
> > > rathern than usb0_drvvbus. This patch makes it possible to use an
> > > external regulator to handle the VBUS switch through the 'vcc-supply'
> > > property of the underlying generic_phy device.
> >=20
> > OK, I get it now. But why would not use usb0_drvvbus ? You could still
> > route usb0_drvvbus to the regulator enable pin and the regulator would
> > be enabled for you once correct values are written to the IP's mailbox.
> >=20
> > I suppose this has something to do with layout constraints ?
> >=20
> Yes. The usb0_drvvbus is used for a different purpose.

alright, thanks for the info. I'll revisit this in a few days, quite
busy right now and my tree is closed for v3.17 anyway.

cheers

--=20
balbi

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTznmPAAoJEIaOsuA1yqRE2t0P/2mqdISbHWQllbdxLBZtbrsI
pPQoKKJAeSrZVX3rXde5CSlHl/RDzJYO93gxFV57sa48mtxt6YPXowy3myHIiWGk
DlGzvwIqk1vpZ4jEXQvihnRkxC3fHnCrwDuqTqqVS9/4gWWL5S01ex7+FSo3kJFN
ZujmeLdf/nT+AiEobHKDr8mdNs7yhB8vM9Z7Wf0+NQLLqaR4w3Hz/UfnxSAnitHo
Pp0RNEI4A8lx5F72sJV2SkHUbfmgzsW11wPq5QX/xhRS4Gl/++5/1BxKUYjzKC+J
wwnOolwlKuE1SZcBvh93LAUdc2IxIfSd8JT2zpUeNq3LvA8MiHENxZGTtGCK36+5
Ck+EREGxXt26+zUXiL8ITVxaQhrEnCxeJS++dJcuyG7FUHSouOHso8wMZrqt6vZX
KoVsBS+nxNE3rapltGbNZMdZWFRrfXVuKPc1uJMHw+qA+l0y88K/JZg7orUVK9Ya
1iZlv/CVmQOwfCxuwpF0jCvL7WtOf4y53E4XI+mHw3AvA8yxynpX9s4Rd/OjxHGG
H5qHcN2/8INaJOwWgt4MBwdtFpsirH6x+9SlvoTacomJ8Ei403Z0kqM9GOvXIx3P
sknwMdb/Ws1IrKp+xSiLnVzGQbD0+slpXg4vIVMrA8qEMFa51hOICWngaW5b0xzh
Z8L64NScR/M9C+hgqxBX
=WzjG
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
