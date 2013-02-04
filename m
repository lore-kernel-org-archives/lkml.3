Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3BDIGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:06:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:5363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3BDIGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:06:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="asc'?scan'208";a="252217965"
Message-ID: <1359965280.13791.12.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: devices: elm: Removes <xx> literals in elm DT node
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Philip Avinash <avinashphilip@ti.com>
Cc: dwmw2@infradead.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com,
        hvaibhav@ti.com
Date: Mon, 04 Feb 2013 10:08:00 +0200
In-Reply-To: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
References: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xwUgq7gi4ffNHM1Nna01"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xwUgq7gi4ffNHM1Nna01
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-24 at 12:23 +0530, Philip Avinash wrote:
> As part of removing generalized dependency, replace <xx> literal fields
> in DT compatible field with <52> for am335x platforms.
>=20
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-xwUgq7gi4ffNHM1Nna01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRD2xgAAoJECmIfjd9wqK013EQAICi9n36zs4RoRxN98qurA+K
r7blCtPgWEi4TpxKXD9TYAGlMtEgkT7zhD7RfH+k7TC42mo2pWmSLcMPwmmkSOX0
SbWcgqEy+N498K+Id25W6yNX51qLlrQ/GWvLWtMw9seOiYz3Lt6jr+cCGTZI3ZO6
ZO6gOD+7jlqs1R1aGUGQR5NOqdGQcqARCmbm138p0AJzL1+qatLxUV8i+xaHUldB
TQzr0tR7uH/mH1PFAsxs0LVWjJS1REXQGQKY980hnUVNcGwPEiURXbSUFyn1p4ai
2DHCihDX3p2oKOH1gVLDUQp2amTtZvhoUyJSiqGAO9auDOTSP0No2iP4F1tlTRJo
43Drn+GNZgYRs4zuXGBQI4S9tt0nUlgc3/Q0eBDjA79X5CH46U4aVxw6kDKfFeUV
g9IkYIvq2MKqd4Ka3gZ4mdb8OmWSEEuTLP8FKLkmc5cwCLdXnRr2yevTi4YgbqiA
LDdFic6BoMDeJ2MDm+m2J0xZsMKgkj3RNOYnh3QsV4/onOWmoMD4Bv3IOP1vVF5L
yR26vRMq/zBUpEQb1hrSQM03L0P7AgDJnDOz6Rj8KLnLrUaUz5oEG1yiuvkcuvu+
D2cAPqkMG+IvuX+tBVYIb8vW1cEyxzvb8uru1i99IgpSHckoN/ppr/rQxYWrK4GS
sI/PtrEftGSUjTtxIhRn
=7p52
-----END PGP SIGNATURE-----

--=-xwUgq7gi4ffNHM1Nna01--

