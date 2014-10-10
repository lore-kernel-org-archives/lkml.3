Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaJJSKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:10:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60849 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaJJSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:10:50 -0400
Date: Fri, 10 Oct 2014 13:09:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] ARM: dts: am335x-bone-common: enable power off and
 rtc wake up
Message-ID: <20141010180941.GZ31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-13-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Shs6nLsUBL77Lfu"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-13-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3Shs6nLsUBL77Lfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:34PM +0200, Johan Hovold wrote:
> Configure the RTC as system-power controller, which allows the system to
> be powered off as well as woken up again on subsequent RTC alarms.
>=20
> Note that the PMIC needs to be put in SLEEP (rather than OFF) mode to
> maintain RTC power. Specifically, this means that the PMIC
> ti,pmic-shutdown-controller property must be left unset in order to be
> able to wake up on RTC alarms.
>=20
> Tested on BeagleBone Black (rev A5).

one thing though. IIRC, rtc-only mode does not work with ES1.0 and
beagle-bone white uses that. Perhaps move this from bone-common to
boneblack.dts ?

other than that

Reviewed-by: Felipe Balbi <balbi@ti.com>

> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dt=
s/am335x-bone-common.dtsi
> index bde1777b62be..d0693bea9580 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -298,3 +298,7 @@
>  	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
>  	cd-inverted;
>  };
> +
> +&rtc {
> +	ti,system-power-controller;
> +};
> --=20
> 2.0.4
>=20

--=20
balbi

--3Shs6nLsUBL77Lfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCDtAAoJEIaOsuA1yqREWf8P/iqU24io1reUA9Jn8NNwE++X
cGLV3Pf5Cijy+EzwDakpLlC/vA0Hx62dtl0pM2dkhYDUoHmkeecnm7qNCeu7OG69
IzbjGesgy6XnbhFJK73ADwR5ndq0VGbxnOiDRvbBShaW9yY+oVDvYa110GlUfbfd
BW86KKxR3Okrv7HuPM7pb6PZI4FEWmJj6sDhx5xXwQOLcd8q5w6tc+1Tud7fqAkw
mIqOM5f5PC6CZlKFleXBdRm/7TucALieGZJBBZv3kED5viXXf12THpQt0GPf553r
Cl+bEsDYHxFU6SMhnWaiQ+kupX5vx5BJbvO11m3i4NNpGHJIrY/TZK6Upvu7td/S
1EFizNmUIZq/MRLl8ZS6yT90/tqUZFBIwYe5AucFRxQ/Dpna/NdYNX8ANrurXIVQ
uGqXl1AOUiZW+hVyb5oNH7IqEuQtJsIUbcXqFH9wNQy0hIdvnoyGbmeBDAEDuFE7
GbR2vlyQtcys/OX0Z6dd3t6XUfzWrnTG2drXjRtVbLwCbKCkiMc+qfCKd6D6Y0dN
ie1IwoYQbulWos0v6Nr4hwpSgpY1FizxkU0T6OEcTTfTAedGncXpoV2GN78XBCcK
LXRKOVhLJCerlKkPw8ijx4X/qnpjpdVwiiBF/TcGF4IMH6/54sOIv5Njx0cgCIeE
lsfkOxIUPxQW8sBaHyqZ
=oFcg
-----END PGP SIGNATURE-----

--3Shs6nLsUBL77Lfu--
