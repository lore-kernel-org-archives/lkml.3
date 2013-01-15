Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3AOPEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:04:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51656 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3AOPEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:04:50 -0500
Date: Tue, 15 Jan 2013 17:04:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>, <balbi@ti.com>, <grant.likely@secretlab.ca>,
        <b-cousson@ti.com>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <ravibabu@ti.com>
Subject: Re: [RFC PATCH 0/7] usb: musb: add driver for control module
Message-ID: <20130115150432.GB26272@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358239378-10030-1-git-send-email-kishon@ti.com>
 <201301151341.08297.arnd@arndb.de>
 <50F56A1A.3040504@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <50F56A1A.3040504@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 15, 2013 at 08:09:22PM +0530, kishon wrote:
> Hi Arnd,
>=20
> On Tuesday 15 January 2013 07:11 PM, Arnd Bergmann wrote:
> >On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
> >>Added a new driver for the usb part of control module. This has an API
> >>to power on the USB2 phy and an API to write to the mailbox depending on
> >>whether MUSB has to act in host mode or in device mode.
> >>
> >>Writing to control module registers for doing the above task which was
> >>previously done in omap glue and in omap-usb2 phy is removed.
> >>
> >>Also added the dt data to get MUSB working in OMAP platforms.
> >>This series has patches for both drivers and ARCH folders, so If it has=
 to
> >>be split I'll do it.
> >>
> >
> >The series looks good to me, I just had a minor comment on one patch.
> >
> >One a somewhat related topic, I wonder whether there are any plans
> >on your side to change this driver to support multiple bus glues
> >to be built for one kernel image. With a multiplatform kernel, we
> >may need all of TUSB6010/OMAP2PLUS/DSPS/UX500 for instance.
>=20
> We don't have plans as of now. I actually don't expect any changes in
> the driver other than the Kconfig changes. Anyways the probe of
> glue's other than the platform it's running won't get called. right
> Felipe?

AFAICT there's nothing preventing those from being built together as
long as you don't use DMA (yeah, that's a touchy subject still with
MUSB).

If there are any build breaks, please report them so bus glue owners can
fix. I see that at least the davinci folks need to work a bit

$ git grep -e "mach\/" drivers/usb/musb/
drivers/usb/musb/da8xx.c:#include <mach/da8xx.h>
drivers/usb/musb/davinci.c:#include <mach/cputype.h>
drivers/usb/musb/davinci.c:#include <mach/hardware.h>

I'm adding Ravi B to the loop here for those.

--=20
balbi

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9XAAAAoJEIaOsuA1yqREut4P/2PKEH4M0PDQerPL2ldYCI3Z
ygW+V0WD/6kXaGA8Wp67MyMZ0kEaHF1hRP6UWxjPIYs0AHrNF1NAMxGczdq8lqf0
M1VWH1Gv1G+iAzZMBYkD8E5sKMuXESwTa1lKMEAPyOj4EiUqQrUqvAMDCqcbrqyE
0epclFzt3CxWD0V8J8Afzob5ZV2KcjzvUIPcx5bqaR9nLF9AeeGo5XqyAIfLk+DC
BeoIzD9ttcgq48zp6qp7RnGbty+0N6oUhDVEq0njLaLzfOXNfG5BXGPykqRnIWpw
YXaIntnx1oCKdijVAN0uj5Q6wQ68XA9Sr7KpkMJOV0E3dJz+BuYOqu+eGvF4aOEu
kTctokU5jJtSP03lkOfM45hw2MsAFciq3VGof5Zbd+VV2JGbGDOzTeFD/puUzVTp
/8Fdrjg9RO5gSMSVnfpiD5uG9HLflXyshPmOazHVVFXWEEZRhRNuPkB7NGPs7Dok
JvHkskecvYABOt8bljtbuwymZoR9wjgiu4z4k2fVBrPYgrSPf/f/HwWlfwmuGTql
EjkIWw05MU69gj74CUXem2aKUQnLzAKFQyIhz9Xyj8kiCUdPsNyOVUkImzGZxm+t
7BGlLaz8EWPLMJKoLVtHlXP8SRUowu3oJxUu/Y0hbKusdHruwuzvU4Dwi31Ayi8T
buK1QYVnV0OwbkP26h/P
=q/RF
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
