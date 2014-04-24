Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaDXBbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:31:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36401 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaDXBb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:31:29 -0400
Date: Wed, 23 Apr 2014 20:30:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/6] soc: ti: add Keystone Navigator QMSS driver
Message-ID: <20140424013053.GC13374@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
 <1398296783-1176-5-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <1398296783-1176-5-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 23, 2014 at 07:46:20PM -0400, Santosh Shilimkar wrote:
> From: Sandeep Nair <sandeep_n@ti.com>
>=20
> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
> the main hardware sub system which forms the backbone of the Keystone
> Multi-core Navigator. QMSS consist of queue managers, packed-data structu=
re
> processors(PDSP), linking RAM, descriptor pools and infrastructure
> Packet DMA.
>=20
> The Queue Manager is a hardware module that is responsible for accelerati=
ng
> management of the packet queues. Packets are queued/de-queued by writing =
or
> reading descriptor address to a particular memory mapped location. The PD=
SPs
> perform QMSS related functions like accumulation, QoS, or event managemen=
t.
> Linking RAM registers are used to link the descriptors which are stored in
> descriptor RAM. Descriptor RAM is configurable as internal or external me=
mory.
>=20
> The QMSS driver manages the PDSP setups, linking RAM regions,
> queue pool management (allocation, push, pop and notify) and descriptor
> pool management. The specifics on the device tree bindings for
> QMSS can be found in:
> 	Documentation/devicetree/bindings/soc/keystone-navigator-qmss.txt
>=20
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/Kconfig                  |    2 +
>  drivers/soc/Kconfig              |    2 +
>  drivers/soc/Makefile             |    5 +
>  drivers/soc/ti/Kconfig           |   21 +
>  drivers/soc/ti/Makefile          |    4 +
>  drivers/soc/ti/knav_qmss.h       |  386 ++++++++
>  drivers/soc/ti/knav_qmss_acc.c   |  591 +++++++++++++
>  drivers/soc/ti/knav_qmss_queue.c | 1814 ++++++++++++++++++++++++++++++++=
++++++
>  include/linux/soc/ti/knav_qmss.h |   90 ++
>  9 files changed, 2915 insertions(+)
>  create mode 100644 drivers/soc/Makefile
>  create mode 100644 drivers/soc/ti/Kconfig
>  create mode 100644 drivers/soc/ti/Makefile
>  create mode 100644 drivers/soc/ti/knav_qmss.h
>  create mode 100644 drivers/soc/ti/knav_qmss_acc.c
>  create mode 100644 drivers/soc/ti/knav_qmss_queue.c
>  create mode 100644 include/linux/soc/ti/knav_qmss.h
>=20
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 0e87a34..8993913 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -148,6 +148,8 @@ source "drivers/remoteproc/Kconfig"
> =20
>  source "drivers/rpmsg/Kconfig"
> =20
> +source "drivers/soc/Kconfig"

This hunk was already in patch one but in a different offset in this
file.

--=20
balbi

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWGlNAAoJEIaOsuA1yqREpxUQAIXkhbWyzQYaxEZjeuQ8hCdf
/k4k6NJRySt6eowfh8emS6lIx0dvZkPqx1AQ5aPJKyOGLdsy1iUcnbL378HcTqPE
xtih1r9w/6nppPPAkZ3Z1s6+XH/IfkaBQOWvq84rlO0dv9Sx/ktmL7uup1Ic2XBU
5Yd0+PHd5iPdte07cfJRmmvKrQCck3M3qp0xr7KV8p3mtewNyQvix8UIVXmJ8Pdd
yyo3bongZwB0xLGsu4phAXiOXsxsOA4mucpBTjxcog2WgBn1ykJaeGMUjQD7LviI
K8JYlIKjEGZOLJKqFAD4oihX+/2/62pBmTPSSI7ebmh9x2/K69dbpRU4sGA5eCzQ
JZGpnieHsOmtF8IQ+plZFNRj3itwQOWyz6XXiLd67pElVVNuU9uflMBJJacTOBGX
+oB4UhygNOYpw+87UvT3WFH9FK5iKVPiRSWW+dlYKEagy/NKtG3DZLOjxGVHQDy6
cZ97jP4/QTSe5AofnZKC9jlIXjv5iIB1dZTzhLwDnVLj7B+1IjEupiJysBVAQBZF
0L3NCgcNT3kI4BU5FnwSU5yAd1XJnSUkSzYzbFCTdFzITaIu7X/G598RGsoL7O/i
lb7gEZCGqOke0FOxamwnXypZvLtC54x0VM+QC7Cdbq0rbtioMUxs1HNoru2xJp9F
H5kLQ3FfzXQ5v8Dzk8VY
=V5it
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
