Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaANRaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:30:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaANRag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:30:36 -0500
Date: Tue, 14 Jan 2014 11:29:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Anna, Suman" <s-anna@ti.com>
CC: <balbi@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 7/7] hwspinlock/omap: enable build for AM33xx, AM43xx &
 DRA7xx
Message-ID: <20140114172901.GB27374@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-8-git-send-email-s-anna@ti.com>
 <20140114131207.GB10818@saruman.home>
 <52D56B13.2050409@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <52D56B13.2050409@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 10:51:31AM -0600, Anna, Suman wrote:
> Felipe,
>=20
> On 01/14/2014 07:12 AM, Felipe Balbi wrote:
> >On Mon, Jan 13, 2014 at 06:19:24PM -0600, Suman Anna wrote:
> >>HwSpinlocks are supported on AM33xx, AM43xx and DRA7xx SoC
> >>device families as well. The IPs are identical to that of
> >>OMAP4/OMAP5, except for the number of locks.
> >>
> >>Add a depends on to the above family of SoCs to enable the
> >>build support for OMAP hwspinlock driver for any of the above
> >>SoC configs.
> >>
> >>Signed-off-by: Suman Anna <s-anna@ti.com>
> >>---
> >>  drivers/hwspinlock/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> >>index 70637d2..3612cb5 100644
> >>--- a/drivers/hwspinlock/Kconfig
> >>+++ b/drivers/hwspinlock/Kconfig
> >>@@ -10,7 +10,7 @@ menu "Hardware Spinlock drivers"
> >>
> >>  config HWSPINLOCK_OMAP
> >>  	tristate "OMAP Hardware Spinlock device"
> >>-	depends on ARCH_OMAP4 || SOC_OMAP5
> >>+	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC=
_AM43XX
> >
> >how about just using ARCH_OMAP2PLUS ?
>=20
> We do not want the driver to build in OMAP2-only and/or OMAP3-only
> configurations, on which the hwspinlock IP is not even present.

It won't be enabled by default, will it ? You're just saying that it
_can_ be enabled. In fact, I would go one step further and use:

	depends on ARCH_OMAP2PLUS || COMPILE_TEST

your choice though ;-)

--=20
balbi

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS1XPdAAoJEIaOsuA1yqREOiMP/A1Pl6Sluq6jyk+3BcWR9QqM
Fj2F5V8hW5VCVKYqn8944yUZ/Jhi30rVtGNwcWm/obMOM4Y4o0iCwl4iAT26szjG
py9Ij2Fvnd8QaT0ytz04to3Sd6VTsB2xWW5PkgUI/yM7aTknBHszXGA0waDT7XXV
CHWnhXRQ5zSbY7WxXCXELed7Mom/nhSiry0rocJxpVJFq0jnZ+gM+8Bonf6ozn+y
Q1JathiBrSUzC0hij6md2TJh6i5cUxVtG/wzbw3hqHs06EwqHm/exoJqquiorRIt
TPimHFGHK97F4OzJ0vTVcrNmIZGwHHBNXZ7CtW92owpRXiJ/UrhVF3NZPkGzKlxu
7XZwL67NO3jqO8u8a6gaRLdg/sz9884hZXjGmkuv43rLFBB3pSg9HZF+UDYwozqj
Ly1bnRfFHdTQdRUjmNQRNybh51d8v1x9LhnmHRp9iDqDG+uxhZZJzjjD2M4O9h4T
21ju2rYyD+0+6xvVjHb/sP91PpnXtzh4RwhU+ZOFCJ/cO3Ly+UmGdlSIL5Zdw3YX
ezY7tJMkFd+5wgqcvWuYTSp+Lw3ekMQGN08ldJbAKt55LZAcbTe2Ppx+oV8T5ao+
rPjlEB98FTn+L86YS1urPvQRVLaVDznipdetwI0ZpDV9cx2AG32P2DySK9NaqlDz
03Vv8bIvJOzEaNNJRGPh
=FVki
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
