Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3ARLru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:47:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52908 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3ARLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:47:48 -0500
Date: Fri, 18 Jan 2013 13:47:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <balbi@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] usb: musb: add driver for control module
Message-ID: <20130118114731.GA4379@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1358239378-10030-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 15, 2013 at 02:12:51PM +0530, Kishon Vijay Abraham I wrote:
> Added a new driver for the usb part of control module. This has an API
> to power on the USB2 phy and an API to write to the mailbox depending on
> whether MUSB has to act in host mode or in device mode.
>=20
> Writing to control module registers for doing the above task which was
> previously done in omap glue and in omap-usb2 phy is removed.
>=20
> Also added the dt data to get MUSB working in OMAP platforms.
> This series has patches for both drivers and ARCH folders, so If it has to
> be split I'll do it.
>=20
> This series was developed on
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
>=20
> Did basic enumeration testing in omap4 beagle, omap4 sdp and omap3 beagle.

can you resend without RFC tag so I can apply ?

Thank you

--=20
balbi

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+TZTAAoJEIaOsuA1yqREsScP/34CWYF8lCszxE4JnttVT6ss
R9DBLkNy9YARvIPlabfVGIPxwR090gumMaVQZJX4PoeEVwV9bBIQnCaYNy/VoEGA
1J2aBO8Qhce/wBIfPoFPNFyWI3BO78w+KZ25NhDpR1oFAr0kWaEX21wVYvkRXzZE
3IdWykSn+BMqKrTG2AK2GdvNA/PBoPROrMk2zhsulXjwSdwNVXq6otuhxqDq5a7K
WYaqz+KV4ou+NiX/uz+NtdmGsSV/nO+Zpmm0WZ9kFkMAIob+DrZ1fiiEokhQhyDk
0BnKgjABPpEDW9hE/xeINBwt285SpyiEkhoUqQBeHdFFV6C1ZtApkw05/4BjT0ln
DWs8vQHw4CMcdWAUY3wOQUNvi4GzlEjLINZHfvU3HHv2vZm4EDRnLf0Jt2xTuEbX
119b7gU1Bj610XfOJun2HjuQcmVFZbB930gQ0Sd0V+IwWT9uWjMOu/Fb7sqeyjhV
Gf0VaqusLnV9wkCJoMlilTQ14ItL+bAtoJ5dZqKk5XrAY1X2ik4ZrMPyeXNvEoRq
/DmmUnHJwJP6U7DMKmgB75WNmd4uGm4RuP94XndUnIcdbDer/lpsVAZEyO583B9W
KlWMtpMA42vXJ+MyNRO8hGsxRormBLXRsuf3kr8sgFWsBTRYleNTwcfg+1RmuOdQ
PtLRocrVaAcoFIcFs0ob
=58vG
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
