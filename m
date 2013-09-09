Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3IIORF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:17:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36602 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3IIORC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:17:02 -0400
Date: Mon, 9 Sep 2013 09:15:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Koen Kooi <koen@dominion.thruhere.net>
CC: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        <stable@vger.kernel.org>, George Cherian <george.cherian@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCHv4] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
Message-ID: <20130909141531.GL9325@radagast>
Reply-To: <balbi@ti.com>
References: <1378734350-30479-1-git-send-email-koen@dominion.thruhere.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gt+ay4QFgFrjOKz/"
Content-Disposition: inline
In-Reply-To: <1378734350-30479-1-git-send-email-koen@dominion.thruhere.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Gt+ay4QFgFrjOKz/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 09, 2013 at 03:45:50PM +0200, Koen Kooi wrote:
> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI=
 added,
> so create a common dtsi both can use.
>=20
> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI tra=
nsceiver=20
> after a dozen boots with an uSD card inserted because LDO will be at 3.3V=
 instead
> of 1.8.=20
>=20
> MMC support for AM335x still isn't in, so only the LDO change has been ad=
ded.
>=20
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
> Tested-by: Tom Rini <trini@ti.com>
> Tested-by: Matt Porter <matt.porter@linaro.org>

not entirelly related to $SUBJECT but having HDMI listed in BBB DTS will
prevent the use of RF cape, no ?

Other than that, patch looks ok to me.

--=20
balbi

--Gt+ay4QFgFrjOKz/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSLdgDAAoJEIaOsuA1yqREBKIQAKqHuKLQTU5AsGsXErPrfmQ1
f+M86KifgBeAphi+ergH4mPz0YRi0J8Vdi13kTp7qMlYjAXTUGIB7jFfnuJW8XZ7
wcpc3SWPpCcJPceP0pJA63GZQLO1t+tOTaWE0xYnsqCqxx5RPoenITzbL6Gh3Zk9
wTzci1CiZKzNPktAYbOxTza7rDhxfllIigbuegJV2NIiWOmCiovXaNklc0wKturI
BdTGUJ7A5/wGauy6iweeVLTV79BhVy9JlcC4dA/evH0yMlNWeb99lM9+lAZZl0ab
8hKZUtaS3sx7RvBCnROR8ne7RZpRHCnvqGFCnsmihZxb7hjR9cyuZTukZZjtvc8Q
5D+CqJ0W/9/lc0G9zwiHy/ezS+zcNyqquxnxqcv+E2Uwh2pZf2YmBprZt/7GGCIJ
BFByAv1A+dKVQK+8eHnGJFiiv5eGUYldxutYJp7SYquK92RAOT+PoliRjuEumh7/
iyomVSX5Ru9CUoRN9/LpEnZLH6PpWmAhz71HV8swS3/zyRRMivYn19KE6SNRG1zh
sF8mVaWhVnwG/TEq2xGWi7yQPFvFWnNNgZ+JsX/I60wcu76N9kfwxHeR+ZG9z8yV
+P4azU2rRKD3RSfRrOxosFqylgJYHhs/xTGQNcEMF7+TUl+SpIcvlfynTB9dX8CM
RmrY5RCNtjRUT1AKxWvu
=haOy
-----END PGP SIGNATURE-----

--Gt+ay4QFgFrjOKz/--
