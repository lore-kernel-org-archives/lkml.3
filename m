Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbbAHRJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:09:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38647 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbbAHRJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:09:15 -0500
Date: Thu, 8 Jan 2015 11:08:15 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jisheng Zhang <jszhang@marvell.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] usb: dwc3: add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY
 quirks
Message-ID: <20150108170815.GJ31926@saruman>
Reply-To: <balbi@ti.com>
References: <20141208213551.38860f81@xhacker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
Content-Disposition: inline
In-Reply-To: <20141208213551.38860f81@xhacker>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yr/DzoowOgTDcSCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 08, 2014 at 09:35:51PM +0800, Jisheng Zhang wrote:
> On platforms which has native usb hosts/phys and pci-dwc3 controller,
> the dwc3 core may get the wrong usb2_phy and usb3_phy by
> devm_usb_get_phy(). It depends on which usb phy driver is initialized
> firstly, the usb_phy_generic or the native/real usb phy driver.

why are you initializing generic PHY if you have a real PHY ?

> Before all old USB phy library usage removed, the solution I can have
> is to add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY quirks and set them
> in dwc3-pci.
> Could such modification can be accepted? If not, could you please give
> alternative suggestions?

we will not accept a quirk to skip PHYs, sorry. A better way of handling
this needs to be found.

--=20
balbi

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrrl/AAoJEIaOsuA1yqRExiwP/iNpNzccMViKA1rTSQvqmvqe
8ziEq544W5IGjUXx6JuyWuTSmWE/w/C+Hi50mcctXbaAu7qY6HWL9NS0XgfxxPFZ
UBGZbf9ppM5MWQBINwcpPlNUHdRkUCJDqgzVWvF83P+k740Pw2Y/eNM2mRuVo3dG
Ubi2hMJcUHZu1s+Hvz7VpvNHEo6JvjD0jr9TgAGcGhkOdsisMbe1vWRXoziHTEmi
gs1ywtbc4B6md5a6m2twuD8gXxV8Hn6h1n8mh6kCjR+qJUlXejWdSKcjXK+2p4l8
bZgGhdjuyvqqpti73RXPmhFYXqVhG9+10JtrME/BmKcCovwLqD73Ee72ho0JvYJS
P2TVmxtOid1aVJdQBtYdVacdEsWDYe6sFq5xhOxvWEiguCmRe9WCKpdsyBMpDXXP
67DT3dLGlhDP7CC9o916iYrf7c+gtLGlHwNpyR8ZwwII32om1vTDLOvToSqKH4ZV
AEEA/g4d8lH6u7Lop2KCHpd+/VNjsh5DCCaJ4HwbTgYrf8l56PGp44nBj0EKLYoJ
Z7Y6Ro0wSLXAYWNSh1UvHtPC4ZqMxxhQpiw4GL9txeXQDHu5Ln6+Q9JRI8DONCu8
HqPacGIY3G75WoKhKeCfHVXginPsqz/qbL2TmJ/Um7pZ0D3ox2WIZlY1UAU5ViAM
WTNQIQUTCht9nA14s1F/
=tuPs
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--
