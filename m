Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3AYHsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:48:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46918 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab3AYHsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:48:45 -0500
Date: Fri, 25 Jan 2013 09:48:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <tony@atomide.com>, <balbi@ti.com>,
        <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gregkh@linuxfoundation.org>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
Message-ID: <20130125074818.GF15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359080391-5120-1-git-send-email-kishon@ti.com>
 <1359080391-5120-2-git-send-email-kishon@ti.com>
 <510218FE.8080606@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AGZzQgpsuUlWC1xT"
Content-Disposition: inline
In-Reply-To: <510218FE.8080606@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AGZzQgpsuUlWC1xT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 09:32:46PM -0800, Stephen Warren wrote:
> On 01/24/2013 06:19 PM, Kishon Vijay Abraham I wrote:
> > Added a new driver for the usb part of control module. This has an API
> > to power on the USB2 phy and an API to write to the mailbox depending on
> > whether MUSB has to act in host mode or in device mode.
> >=20
> > Writing to control module registers for doing the above task which was
> > previously done in omap glue and in omap-usb2 phy will be removed.
>=20
> > diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docume=
ntation/devicetree/bindings/usb/usb-phy.txt
>=20
> This file seems to be specific to the TI USB PHYs, not all USB PHYs;
> shouldn't it be renamed ti-usb-phy.txt, or even better renamed to match
> the compatible value it documents, giving ti,omap-usb2.txt?

could be, but that can be done as a separate patch. It's not part of
$SUBJECT.

> >  add the address of control module dev conf register until a driver for
> >  control module is added
> > =20
> > +Optional properties:
> > + - ctrl_module : phandle of the control module used by PHY driver to p=
ower on
> > +   the PHY.
>=20
> DT property names generally use - not _ as the word separator.

fair enough, Kishon, can you fix this up ?

--=20
balbi

--AGZzQgpsuUlWC1xT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAjjCAAoJEIaOsuA1yqREqsYQAIDbG9pMox9MzMhLTQ3nYziI
UI4lVKJSkHvwAaSrZdUdlt88HQeHD1iDUY9H6S5VFX5L7FnkhtNYvHfcVNpIWlf4
bvB3kCmueLELHn1jhnss8gZzYo+c2jhRNF7rccdVFQ2w5A+O30eVmknphAc5KURX
P80JDFpmY4yfVbHOgkZ6sd2Dqy0GhqRj9nOftN5Rp0FLrnkpa5BqGcgq8WcvmgZ7
Fj5nGHaoTD/MrkbfwtjeGiKAU0zkjBgXIQbKeZT3sqPYrB2/6OKx8MyzWIEtoDK/
imV6BH/gUoIldGjPG5TsaDzcxoEy13waz71pIENTpgIUzahe6MRZelXsDQW4ZBSh
5i2uFYnIbzkJz0yhZ5oURwhP26wfaS5MsXtADAtl2d5P2n9mEFrqXn3mOprSBPup
Bm8xkse21bCLccG6vL84hQNirqTRvl9LICw2R/P3+ly4tNCgrSTMnxDU0BdqZJYB
LKemOPGp/D0iNR6k8cQY15w26Uvb+R5oy7HUPshtAf4W/zePWat3iGN/MapqOue9
vps1bWKdr1qg4K9TpmcLUAOAnnGsg3TtBZSz1gw7GAKanK8FcEohHeRJMLArvThV
c/T9C5sfBw8F21FoXs9DagR+Msv9JBkRpzIHRlDPcY0eqAo3cfrMBFrGqot4M5Et
OEGn/zmfPgNfBA5pqgke
=GAPu
-----END PGP SIGNATURE-----

--AGZzQgpsuUlWC1xT--
