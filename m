Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3GHI6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:58:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43652 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3GHI6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:58:33 -0400
Date: Mon, 8 Jul 2013 09:36:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Message-ID: <20130708083614.GP27646@sirena.org.uk>
References: <20130705201118.GM2959@lukather>
 <5811519.oHVuMujf0I@wuerfel>
 <20130706120112.GA11069@lukather>
 <8997501.Dchyii8uWX@wuerfel>
 <20130707071501.GD11243@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gsdzuQCfFBG/nQPC"
Content-Disposition: inline
In-Reply-To: <20130707071501.GD11243@lukather>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: MTD EEPROM support and driver integration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gsdzuQCfFBG/nQPC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 07, 2013 at 09:15:01AM +0200, Maxime Ripard wrote:
> On Sat, Jul 06, 2013 at 09:06:49PM +0200, Arnd Bergmann wrote:

> > We also have a bunch of OTP drivers spread around the kernel, it probably
> > makes sense to consolidate them at the same time, at least on the DT binding
> > side if not the device drivers.

> From a quick grep, the only one I've seen so far are:
>   - imx6q, that has a hook at machine start to poke into its OCOTP to
>     retrieve some frequency scaling parameters it seems. I'm not sure
>     how the current solution could improve the situation for this
>     use-case, but the DT bindings of the OCOTP is just a DT node, with
>     no clients, so we have nothing to worry about here.
>   - imx28, that has a hook at machine start to look up the MAC address
>     values and patch the ethernet controller nodes to add the right
>     local-mac-address property. This one could benefit from the new
>     bindings, but we already mentionned it, and I intended to develop
>     with an imx28 board anyway.
>   - picoxcell-pc3x3 DTSI has a node for a OTP device, but they don't
>     seem to be doing anything with it, nor do they seem to have a driver
>     for it. So I guess we don't care about migrating for this one
>     either.

> Did you have other cases in mind?

We have some OTP support in the ab8500 and wm831x MFD drivers too but
they just expose the data.

--gsdzuQCfFBG/nQPC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2nn7AAoJELSic+t+oim9dVMP/1u9HxMIB1lyxHbpK5BGT3JR
QXNAmhkmBwdSe2A6iltqMo1KYCCwdscUdoZh3uXZTulTuDSnsd3e/A54K8dble9Q
vII/2Io5lscjwWH9SEoDUIxdhwZlOKiUE6m6JumvgxP91wqTk+dzE74Byk+ht0Xn
+NPiKm+ImJ4GX2Wj+KM/LyVGqNEp37UWCjOtF6+howwRoBmTPJ3gErAYfbi//53J
1XetR1n6RiJT/lRlSPTObITE4IZOqBvWW9Ed0CIAYsrtBmX5xyqDRLtAxmEartV6
KAha5z6X/+wVAZM2U/o460MgUoidV1ePsoHO29G/96TPkX2inL4RKlWXGnkWoY2S
anyDMFHQAGnBCA4DN4pqjF/k2L7GDxUDSByT5cf3tVhWO43jj/tMYBhYA9tQHmgk
+8jET6xQ9mDUTOH+oFKMlj34ChnU8EQow4vHQuh4jDnbk7WmymtkwNHzWPD6C0LP
5Ao3zuQzkPU8yaFIaOvdVddL+ZF0TX9XPIdSFIxy44vIAmzqz7C2V0Opj8aDgr8C
pakvtPersXcY6pf3kML3LblELr1wj3LUV2WcQINhAxpU/lucvrAzBffAW0d7Apf1
EvTN/gfL/Vwvtk0N08f6dXNb/wMZJsKHFGqPwkvOkQu+3lvtn4BnrbN8LYTIxIS7
olPWUCbSLresgTAhzPjI
=GqC4
-----END PGP SIGNATURE-----

--gsdzuQCfFBG/nQPC--
