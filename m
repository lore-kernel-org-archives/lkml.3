Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3AYIp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:45:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36049 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3AYIp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:45:27 -0500
Date: Fri, 25 Jan 2013 10:45:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gregkh@linuxfoundation.org>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
Message-ID: <20130125084501.GI15886@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359080391-5120-1-git-send-email-kishon@ti.com>
 <1359080391-5120-2-git-send-email-kishon@ti.com>
 <510218FE.8080606@wwwdotorg.org>
 <20130125074818.GF15886@arwen.pp.htv.fi>
 <51024581.6020301@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSQ3hISbU3Um6hch"
Content-Disposition: inline
In-Reply-To: <51024581.6020301@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HSQ3hISbU3Um6hch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Fri, Jan 25, 2013 at 02:12:41PM +0530, kishon wrote:
> On Friday 25 January 2013 01:18 PM, Felipe Balbi wrote:
> >On Thu, Jan 24, 2013 at 09:32:46PM -0800, Stephen Warren wrote:
> >>On 01/24/2013 06:19 PM, Kishon Vijay Abraham I wrote:
> >>>Added a new driver for the usb part of control module. This has an API
> >>>to power on the USB2 phy and an API to write to the mailbox depending =
on
> >>>whether MUSB has to act in host mode or in device mode.
> >>>
> >>>Writing to control module registers for doing the above task which was
> >>>previously done in omap glue and in omap-usb2 phy will be removed.
> >>
> >>>diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Docum=
entation/devicetree/bindings/usb/usb-phy.txt
> >>
> >>This file seems to be specific to the TI USB PHYs, not all USB PHYs;
> >>shouldn't it be renamed ti-usb-phy.txt, or even better renamed to match
> >>the compatible value it documents, giving ti,omap-usb2.txt?
> >
> >could be, but that can be done as a separate patch. It's not part of
> >$SUBJECT.
> >
> >>>  add the address of control module dev conf register until a driver f=
or
> >>>  control module is added
> >>>
> >>>+Optional properties:
> >>>+ - ctrl_module : phandle of the control module used by PHY driver to =
power on
> >>>+   the PHY.
> >>
> >>DT property names generally use - not _ as the word separator.
> >
> >fair enough, Kishon, can you fix this up ?
>=20
> Sure. Will post a patch..

Great, notice that I've already applied some of your patches to my tree.

cheers

--=20
balbi

--HSQ3hISbU3Um6hch
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAkYNAAoJEIaOsuA1yqRETN8P/RwW++QD2qrz3hsfMWWY7ADt
VmBXAmAxE96ie8ZbLRLCtyvDpnfyWEJ6VyMYNJOUmEHXBssCAylk2XKnXOJV3fPV
bS1AoMMDfEAOVGYlovbTfaGRb09g2WiVP+1/8r/UXS/b/pP26qB85hFr+h1GFuqK
JMhyd6vZz0AyJvVPJ7StkPixbEF3p+emx6WuwGMn/xWp2O/4XsXiSj5qHuC2YCwk
hxoWFpCDP8ZdIOaVa+AAeMv1zueIV91t9RP6e9BRhGhSnkUiUbNNIpKOE9INgozS
v5EYPVUvbiaL1yGI2mUVP5hpANFyiVrwI4OA78exxrN6Mk7lKutnJzeq8WOf/C6a
7JvFn/yoDZlNDl6kfa18vRZ6vl4/qVKrw/m4T7+PjSnQru46ELq/l1KYNiuzgQ+Z
BOaRX+I8irxTGqcqLtjZag48UVH0FwSlp57gQsw2mfP2JIHsYz2mmTv5F/Fjg9m5
xToCqbRsGGFMwoaXXVfv0xo5Lxi9iZc6h0hlWkDT+cFkOvyrT+Npa6wyzJ6KIWjE
nDVKbnbotRVsH3hjepp9iWZK4zd81XqBUnlGzwdTKkzahjge1yYA9Wm1+PlCPOE7
HBiQ9YSc006AshFKseU9KLUKHA2qTb3vtbxTqKsxnX/lI7a8uq+dvjej/aEG+Lw5
XkBzuSkLatL29vvtyvNt
=DZtf
-----END PGP SIGNATURE-----

--HSQ3hISbU3Um6hch--
