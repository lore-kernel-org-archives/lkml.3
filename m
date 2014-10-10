Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJJFWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:22:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:64160 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaJJFWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,690,1406617200"; 
   d="asc'?scan'208";a="603191954"
Message-ID: <1412918552.2427.12.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2] networking: fm10k: Fix build failure
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>,
        "open list:INTEL ETHERNET DR..." <e1000-devel@lists.sourceforge.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 09 Oct 2014 22:22:32 -0700
In-Reply-To: <1412918346-24763-1-git-send-email-bobby.prani@gmail.com>
References: <1412918346-24763-1-git-send-email-bobby.prani@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-F4jrQqh7Xwoq2M5+sLrV"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F4jrQqh7Xwoq2M5+sLrV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-10-10 at 01:19 -0400, Pranith Kumar wrote:
> The latest linus git tip (3.18-rc1) fails with the following build failur=
e. Fix
> this by making PTP support explicit for fm10k driver.
>=20
> rivers/built-in.o: In function `fm10k_ptp_register':
> (.text+0x12e760): undefined reference to `ptp_clock_registER'
> drivers/built-in.o: In function `fm10k_ptp_unregister':
> (.text+0x12e7dc): undefined reference to `ptp_clock_unregister'
> Makefile:930: recipe for target 'vmlinux' failed
>=20
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Dave- go ahead and pull this in directly, no need for me to put this
through our internal process.

> ---
>  drivers/net/ethernet/intel/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/in=
tel/Kconfig
> index 6a6d5ee..6919adb 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -304,6 +304,7 @@ config FM10K
>  	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
>  	default n
>  	depends on PCI_MSI
> +	select PTP_1588_CLOCK
>  	---help---
>  	  This driver supports Intel(R) FM10000 Ethernet Switch Host
>  	  Interface.  For more information on how to identify your adapter,



--=-F4jrQqh7Xwoq2M5+sLrV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUN20YAAoJEOVv75VaS+3OJNEP/1hB1hpgV5W1RVXaZjeij+If
iXHUVLSy1yfdI7pyl2vfRhGW115dMAOeMd0i6BryPE85tpT5RpfROLSSKrq9IgJT
JxURqHF9pRn29dSDMf5chGieZodEc9MIglCYp6cqyKiBEK+8Jry7RAr9rgUZj8s4
emtmoKWGfn3PcHqszRQYwhLwhq4LzR+V/Retcor5pnjEGWT2X9NFlSXSpveWaQcD
VX4UVJSkhiXR5u6GoDqcgSOyLhOlgScNEMw28IABPgO3OsbgaE4EOiGig44c6oqa
M+6ObBjtwB6VQUqopLAgxKelXiK2UuINny5Yyv36WboxQo4H75wu5wv+GM/VE4b1
q+hMlk8Ada1s0KL6J54wHq9XXDidc/XYvLOBCjEXj90U710wPUIBm5aAc2HUXR9M
wKf4iWX40cr7TFf76g8w48FwU9agoRfdaAauidIXTiIdNFGSl88Q7UgJXlaNnRbP
s6eaIA08s83pFp/kVjtmAntopvQRkHTc+uP40xbz2JOQhBoC8ylque+HuI1QgAJI
IELTI6tkVq6+nY8AburKXA0ADhzlJwEg58OvrLZUJhg++kU7HL2OW7gGqor2Rkj7
uVv9ikexGKetL5OGpLaV+wj8+pleepxwzcqemxAvoIOwEUC3xOv+jkZH+79vZOKc
iqHUB4M66OJSpRYf80AZ
=Jrb0
-----END PGP SIGNATURE-----

--=-F4jrQqh7Xwoq2M5+sLrV--

