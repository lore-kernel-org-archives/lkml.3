Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaFRVwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:52:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaFRVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:52:18 -0400
Date: Wed, 18 Jun 2014 16:51:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <r.sricharan@ti.com>, <robh+dt@kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, <galak@codeaurora.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] arm: dts: am4372: let boards enable RTC and
 Watchdog
Message-ID: <20140618215143.GA8181@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-2-git-send-email-balbi@ti.com>
 <53A1B677.9010909@ti.com>
 <20140618192553.GB4570@saruman.home>
 <53A20800.3070301@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <53A20800.3070301@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 04:43:28PM -0500, Nishanth Menon wrote:
> On 06/18/2014 02:25 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Jun 18, 2014 at 10:55:35AM -0500, Nishanth Menon wrote:
> >>$subject - ARM: dts:
> >>
> >>On 06/18/2014 10:43 AM, Felipe Balbi wrote:
> >>>by providing phandles to rtc and wdt nodes, we can
> >>>let boards enable rtc and wdt as necessary.
> >>>
> >>>Signed-off-by: Felipe Balbi <balbi@ti.com>
> >>>---
> >>>  arch/arm/boot/dts/am4372.dtsi | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>>diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.=
dtsi
> >>>index 49fa596..e3830d4 100644
> >>>--- a/arch/arm/boot/dts/am4372.dtsi
> >>>+++ b/arch/arm/boot/dts/am4372.dtsi
> >>>@@ -270,7 +270,7 @@
> >>>  			ti,hwmods =3D "counter_32k";
> >>>  		};
> >>>
> >>>-		rtc@44e3e000 {
> >>>+		rtc: rtc@44e3e000 {
> >>>  			compatible =3D "ti,am4372-rtc","ti,da830-rtc";
> >>>  			reg =3D <0x44e3e000 0x1000>;
> >>>  			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
> >>>@@ -279,7 +279,7 @@
> >>>  			status =3D "disabled";
> >>>  		};
> >>>
> >>>-		wdt@44e35000 {
> >>>+		wdt: wdt@44e35000 {
> >>>  			compatible =3D "ti,am4372-wdt","ti,omap3-wdt";
> >>>  			reg =3D <0x44e35000 0x1000>;
> >>>  			interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> >>>
> >>we might want to fix up any other similar nodes in dtsi as well, no?
> >>
> >>examples:
> >>cpu@0
> >
> >and why would you want boards to mess with the cpu node ?
> >
> cpu-supply =3D <&regulator>;
>=20
> for cpufreq.

good point, but does thqt even work with AM437x devices in mainline?

--=20
balbi

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTognvAAoJEIaOsuA1yqREBskQAKREx6HXEYwke4wo4t3xX8FF
zFDeDNE+B/UCpydqykKMgzPToNkImg0y2DCIpwvej3Q8yUBZiu2OKA2RSMh6n+F0
zZViCUhGtZC0YN5pNLmPZtBwg4U9ALX9VgfJml2ex58z6fwyEsrt9v4TOUX8x9Xl
ZZvN/xBMtMBaFE+GvVlNHHDd1NHLlnoMOJF6FUFuY8cI5G9kfmnQ19w99JmIXz4+
UrAe0KHe4xezJj/HYlAzbvZESVWs7kv4oQXn4xXK81XYClQ5P7w7ZoAeQ2hJMaCn
iPlxMTa0XincnP9vRKn1FjnYTdlgdvo+FLY3YiNTVOy3W5Gv0JqTk2Aj9UPc0Zb7
nWTclbuYk7O5vWUsDUvPr2BF6+GJbn+7EuBXl/i4CZEwH6U0gEonoPqMKef7/dPs
1tTKYf9vxd4lrCRdQtNiAgY3ilUwNgtpawZqcQG1ro9K9/N7XxNt5yvy5LQGRwKL
2ZKdO9u7ve+p8qed/ZxUkBJUaQ1ToF5Rrc/qUTHz7qIvLoFiS3ImXFIEEBKfoIu+
u6imOilXZLcBKsZE9jUE1kZ43C715jqXHu5PmSIzMUuY0J2hMUO2lfhQZr+NV6U/
mfaFCJb5jhLEePIj38YJc7OIXP9LCrSXooIRKpqumn1cE1eXjyhZPvEwLugBvKJJ
s6cK6OlZnMEG7QMIgU5n
=g5Qg
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
