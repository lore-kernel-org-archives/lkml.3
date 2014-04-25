Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaDYQTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:19:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60241 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbaDYQT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:19:28 -0400
Date: Fri, 25 Apr 2014 11:19:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>,
        Benoit Cousson <bcousson@baylibre.org>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 0/5] Add USB nodes for am43xx epos and gp evm
Message-ID: <20140425161912.GY29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bIBSTgLWjO5xMb20"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bIBSTgLWjO5xMb20
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:39:58PM +0530, George Cherian wrote:
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
>=20
> Changes from v4 -> v5
> 	* Address Roger's comment for the clock data
>=20
> George Cherian (5):
>   doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
>   ARM: dts: am43xx clock data
>   ARM: dts: AM4372: Add USB nodes
>   ARM: dts: am437x-gp-evm: Enable USB
>   ARM: dts: am43x-epos-evm: Enable USB
>=20
>  Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
>  arch/arm/boot/dts/am4372.dtsi                      | 94 ++++++++++++++++=
++++++
>  arch/arm/boot/dts/am437x-gp-evm.dts                | 18 +++++
>  arch/arm/boot/dts/am43x-epos-evm.dts               | 18 +++++
>  arch/arm/boot/dts/am43xx-clocks.dtsi               | 32 ++++++++
>  5 files changed, 165 insertions(+), 1 deletion(-)

Is this applied anywhere yet ? Benoit, are you taking this for v3.16
merge window ?

--=20
balbi

--bIBSTgLWjO5xMb20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWosAAAoJEIaOsuA1yqREm/8P/j/e8Yb+w2xBkrvYyUkVedqb
nMk37PSLIakrEYGvx28YajiJKcegNaUFMBZjNRrzP/abgDt3KIhgyEVt8jEHm4y3
yfJuse9ytTgtyPaBXedFMrQlslRz+AHJQY1OeJu1oZvNzs74PHLkuhaizDhEnprG
YZguqQIsia2qKy9VATzkL/0tk7xH4AyeKgzUmEPIgrTkVg5qvCh67GwDc78Wa2if
hCfERUg7ZuzI6uzMgt/YURn8AjFlDLjC7MzKopNiD1WFYsqzoruD/vFodFjn0gx8
GIA9rZXPjEp12WQb80LfFlkIyFd84oBlN8c0RbaRDwFDAupfMHcWbs/E3uHzztId
GbmAlOI7mRKDA7NIKljf8P79XfS/ruUuhkgh10cnVA07Ar82yIIlJwmI1elgai6o
qJZMeTVzxXeWw9M+qRZsulogPwymGw7KqofJDr5prdogoMeZUMNbSwrWwVlcDrlt
C8BR/s51j0Mx0YzoMNaFE7gh6EFOZE45I1zjMxG9RBq6riyR1Cb1WeyVv4maVUx6
2jr0cZaZAa5MDHMEzlhW4bRzGI8zQHKd02vK0JTXbs53i4i2vzqqE1ifKT1HaLEz
i5CchwS4pro1kSr2Nf8OON6za4tCgvRRR3ZlPNjYKEctMDawseqATNSguNRKFcs9
oP1pku9UZeL2Fr9uCtML
=n8Fs
-----END PGP SIGNATURE-----

--bIBSTgLWjO5xMb20--
