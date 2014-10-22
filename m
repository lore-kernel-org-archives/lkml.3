Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaJVG6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:58:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38001 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaJVG62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:58:28 -0400
Message-ID: <5447558F.90706@ti.com>
Date: Wed, 22 Oct 2014 09:58:23 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, <plagnioj@jcrosoft.com>
CC: Mark Rustad <mark.d.rustad@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] video/console: Resolve several shadow warnings
References: <1413287629-11749-1-git-send-email-jeffrey.t.kirsher@intel.com>
In-Reply-To: <1413287629-11749-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="EtotUrbCTSE98j2H7LcTr1hSaxDg22Ngt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EtotUrbCTSE98j2H7LcTr1hSaxDg22Ngt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 14/10/14 14:53, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
>=20
> Resolve shadow warnings that appear in W=3D2 builds by renaming
> the "state" global to "vgastate".
>=20
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/video/console/vgacon.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Thanks, queued for 3.18 fixes.

 Tomi



--EtotUrbCTSE98j2H7LcTr1hSaxDg22Ngt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUR1WPAAoJEPo9qoy8lh71diQP/2avyd7NGmGHXsylUl0Rdb0v
Zuy1AQowkK1icClbVlOIeZrLdka3N0xMEnGaDfHsUST8IIYME+P9X3x5QTyNwqCf
qRATfzDBwQJcJWHQS/hyHhInSwycYYeaxP+1Wg8zSZxa6XSPAI/mT6wDPLtRY0Uk
VQxq/dKbg+ly2b4Ov8NnlwQo6s0hwNEAcRtnXhwcch5k0yzHIU66YXBbQWu8IBYN
hZS18sPlJlXZKHlbykr+Jd3ZeiWSeigUC++K2BOELI5BL2Z/C5sxQTWgeMuFJX3f
w1T2QO+ymO29EWTSfTvzhBVL/iqHZ67iKpwnLOLjq+F25SuKVQbHvMh+QphOXGWH
cZOc8u6+bsPUdRgEi7ut1DR3mrbMP02Gu7xnLosLkk2WM7HorHQ23mghfVqGKrJ3
TuiqazsiJmv5MPcfzS7pJ3nxWFEv7h04J/S3F2A3psdK3qTEg0dfuc1cZmHJOPrz
VFyYwfD/QR6+wIQGulYHop/2/CZ8O8z1hs279BZ8/JANET9JgSDpOqBRTBBAdo2T
wkjVcbJuH3E0OBaie8EF7seE0DelvHgim8k9szqMyKd6XodfmgsT1Fm9wJ5TlYoA
daqv3R4C3aLrh+uY2t3Kh7e/SzAQsDOkiyeJt7OkRcL3zNBJ+1NSvbUHvswxuSjS
N4ZRPjsbq/KHfRm/9t1e
=3T40
-----END PGP SIGNATURE-----

--EtotUrbCTSE98j2H7LcTr1hSaxDg22Ngt--
