Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaCMPTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:19:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43361 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbaCMPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:19:49 -0400
Date: Thu, 13 Mar 2014 10:17:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v4 0/5] Add USB nodes for am43xx epos and gp evm
Message-ID: <20140313151756.GE4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
In-Reply-To: <1394723476-8580-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 08:41:11PM +0530, George Cherian wrote:
> The patch series adds USB dt nodes for am43xx epos and gp evm
> Boot tested with linux-next + Tony's omap-for-v3.15/dt
>=20
> Changes from v1 -> v2
> 	* Reorder "doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue"
> 	* Address v1 coments on "ARM: dts: AM4372: Add USB nodes" =20
>=20
> Changes from v2 -> v3
> 	* Removed unwanted dwc3_1 and dwc3_2 nodes from am437x-gp-evm.dts=20
> 	  and am43x-epos-evm.dts=20
>=20
> Changes from v3 -> v4
> 	* Refreshed on top of Tony's omap-for-v3.15/dt tree
> 	* Added usb_phy0_always_on_clk32k and usb_phy1_always_on_clk32k Patch 2
> 	* Used the above clocks in Patch 3=20
> 	* Patch 4 and 5 edited the unwanted portions of commit log

hope there's still time for v3.15, it would be great to see these
patches in v3.15-final.

--=20
balbi

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIcwjAAoJEIaOsuA1yqREy6cP/2Ta4rXw5scCNhTWGhu47S44
02mm53HXnC7+i/CXg3K9KAuK356TvJucmhatKRo33dwbVsvbXfSDjB3oakNWSL04
J2093pzsDautlR4jK16J60E+AFE7Ua9vLcrorpRa8pv1rMczNqjyxWLiA1Cxl0Tg
ELACGvhXMSq5DlvLj4A4QyvdI4s8T3WxU3Pkrp9jB9Y2p14pwMq7NnJE5iuL5e87
UzM8OpayKKr3GNYeaC5Fg//q4U6ff9tEyB0bV5RvwZuUGkmtJpvgUNEAbxb6jZP5
jjNk7kgcxlfV8vIts3HeeyKSqgohgTbtooNvh0wPZ4yxyrKLPKGj5m4B15EhdXzx
jLG8R6Ed16osNp1s6h95Y59FkUYnRn/jKchtMeDuF2dmHH0exB94IxFxUvr6ONEt
6+6ogp1xRK8fZPiwe5Za9id6TRECNc+xWfwT9Y5asdlmP8XlnPguSsZoy6j1Z4uZ
Ny8WYXlOBjjtYnDOcGqu3SeY1xbz/luZ7MQn5oeogIyp7BtzlhoiYI3CfP0jZ/cx
b/SAb3m0LD0DIk9Cd+nfU0iByN48h/y2chniApWwLWKn1ifmdMxt+KdX1mZ3hglP
clFBQ4gZALaH6aer6TJ1BAq8BEDuOdNBeLYSifl1ZNgw/RboKqk9MbZuYtEGdNY+
Dqs5IaJyZEZYx0GT/9D0
=zyWB
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--
