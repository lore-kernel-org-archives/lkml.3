Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3CTNM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:12:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40557 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab3CTNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:12:57 -0400
Date: Wed, 20 Mar 2013 15:12:40 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH 0/5] usb: musb/otg: cleanup and fixes
Message-ID: <20130320131240.GA15157@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <1363164430-19118-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 02:17:05PM +0530, Kishon Vijay Abraham I wrote:
> This series has some misc cleanup and fixes. The fix solves the cold
> plug issue in omap3 which some have reported. Developed these patches on
> Linux 3.9-rc2 after applying http://www.spinics.net/lists/linux-usb/msg81=
563.html
> (Grazvydas Ignotas patch series)
>=20
> Tested for g_zero enumeration in pandaboard and beagleboard in both
> cold plug and hot plug case. Any kind of testing for this series is welco=
me.
>=20
> Kishon Vijay Abraham I (5):
>   usb: musb: omap: remove the check before calling otg_set_vbus
>   usb: musb: omap: always glue have the correct vbus/id status
>   usb: otg: twl4030: use devres API for regulator get and request irq
>   usb: musb: omap: add usb_phy_init in omap2430_musb_init
>   usb: otg: twl4030: fix cold plug on OMAP3
>=20
>  drivers/usb/musb/omap2430.c   |   22 ++++++++++------------
>  drivers/usb/otg/twl4030-usb.c |   35 ++++++++++++-----------------------
>  2 files changed, 22 insertions(+), 35 deletions(-)

this needs to be rebased against my 'next' branch.

--=20
balbi

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSbXIAAoJEIaOsuA1yqRErUkP/AjduTc5xTRXX/YYPnWfHLnF
bSFKycxf19XSSserz3nX1q+sSPqQpCIwxFhhHZxTMjou4SAsMtjfSMX9SHBfc4jx
TG1rElChK4h0DRUKRTOC43484q6WCUGUwnRRvaTmRz5sAJaAI377safl8wCUSt3T
zWyjqDqHASJWjIr+ouDdUs5SWJ6fYEuRQCjBomva2n6I0yS/7uEpemx3R7llXHI/
MilE/Hy+XIlTY7Kv0IjhfzMp6TFev7qXCCEgy0Gi0ylXWHJ6KKrTNozDau3iSYBH
qSxfUFS/PU6WguWbZ9l+pr2XIhe58ogiiOTRJheYLZLRQJhxHeCF+oOC0uyBUmRN
EQakgWxnDc4eOiHt2tP1RlowOXwSi9/aD91htZ03zVUJD2CWoJ7vCv6Cmu1q80z/
oWXYh666Na5N9B9S0W6QIvaP0vXWNW4AQ69hYp3M0gf0betUPphMuwfEqYnqtQL2
ChH7otbxhjBCkPHsWrcI6750fQFZVuVKPi/gB7Rf8XV2Q0zCzrjwhVJknj+DMoZK
V3SA0a6AbZyVmRk2avhEOSi/1mHFIaZNXMQN8soOU16ZUMVV9rTaUSaphlqgQ8wc
/vnpb2Xkn2PTp3i0sLLVm9EnEeDwnS9Xzxp9SW4xWlwJhBjugZbNwCVdb1INi6Ba
Gd7ASLtLpETWUHUC1ZOd
=c7nc
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
