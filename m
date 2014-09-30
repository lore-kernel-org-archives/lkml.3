Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaI3Lpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:45:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57110 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3Lpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:45:33 -0400
Message-ID: <542A97C7.6010506@ti.com>
Date: Tue, 30 Sep 2014 14:45:11 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] video/atmel_lcdfb: Introduce regulator support
References: <1405427605-5288-1-git-send-email-alexander.stein@systec-electronic.com>
In-Reply-To: <1405427605-5288-1-git-send-email-alexander.stein@systec-electronic.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9bW0oKS4t3Iw6uP12DBx3Qoglqb5Rkwt2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9bW0oKS4t3Iw6uP12DBx3Qoglqb5Rkwt2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 15/07/14 15:33, Alexander Stein wrote:
> This adds regulator support to enable/disable the LCD voltage, using
> 'lcd-supply' as regulator name.
>=20
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
>  .../devicetree/bindings/video/atmel,lcdc.txt         |  3 +++
>  drivers/video/fbdev/atmel_lcdfb.c                    | 20 ++++++++++++=
++++++++
>  2 files changed, 23 insertions(+)

Thanks, queued for 3.18.

 Tomi



--9bW0oKS4t3Iw6uP12DBx3Qoglqb5Rkwt2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKpfHAAoJEPo9qoy8lh71yRAQALImWgfmXyQ1BMCMMLyPf+bk
vkeozPHNr0Y4gCmp8gXfsTnLIo4Piq7iqHyAvllNREnTlgcGnWQi3ssiX/4Ghz/q
JtTWELsN/7PrRNPULgGn9Hdk7mdMECpuzv4I4kBD5hEvOWUy7SrlSgEA197emACB
N9S+Y6DfnVCql2umGOiGFZDvcnvRFHWkNaKOs4c8hLz2M+DaxsF5MMF6d7aw59Ut
EvhZZ13gKmwZTAtec4KtcYADv0YENyg8bqtBTdiv3Sscq9QVO0Ou4e8cb26AvCvq
oO+nmYodGtrVb6D/qLYZrzzoQnSyqLZarGnbZTbVjL22g8bEHlXSaqF2+fBNS6sg
iZDXmtGP/uwsSWy0cNpw4eCeMm5gomE0KVl+ej9p3pdqLZcdYLDpuKXRkAuG/lBr
dy8envSmPIQj8iU0g2+1S0JtWnKq5FQmrZrxR4gsCb9qpcA6soFtY/L99iUI05ZF
J1bVJ6/3kVvnlpMYY7Hb6YSV/fsebTqfEZXC9VOdTbv59ARIEbQIeYVFS32liPfj
KwwQGiNUS05UbkNnfRBdg1kgAMXgbc6nvgZ/SWUnIwqqNV4hh6GZxrXitQsTSWGl
e41+VYvEIhihaCb1K3eyyKf+5WXaYNSFWB2LSmwGs/1VO9+qnWvA2RrEgzKW/FQb
2AkxM9FCm432okixQrhx
=0x08
-----END PGP SIGNATURE-----

--9bW0oKS4t3Iw6uP12DBx3Qoglqb5Rkwt2--
