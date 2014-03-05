Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaCEHCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:02:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53592 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaCEHCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:02:00 -0500
Message-ID: <5316CBE2.2020302@ti.com>
Date: Wed, 5 Mar 2014 09:01:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20140305143219.1613f7dcad9ab8a3290be9ee@canb.auug.org.au>
In-Reply-To: <20140305143219.1613f7dcad9ab8a3290be9ee@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9BeBre8NBj4DEi7b3HJVr1MXlbLm8MeL0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9BeBre8NBj4DEi7b3HJVr1MXlbLm8MeL0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/03/14 05:32, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> After merging the omap_dss2 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/video/fbdev/aty/mach64_cursor.c:8:24: fatal error: ../fb_draw.h=
: No such file or directory
>  #include "../fb_draw.h"
>                         ^
>=20
> Caused by commit 236c52f2ad52 ("fbdev: move fbdev core files to separat=
e directory").
>=20
> I have used the omap_dss2 tree from next-20140304 for today.

Thanks. It was a bad merge between the main fbdev changes and the fbdev
restructuring. I've fixed it and pushed the branch.

 Tomi



--9BeBre8NBj4DEi7b3HJVr1MXlbLm8MeL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFsviAAoJEPo9qoy8lh71EhwP+waGY29zzSoryRxP3ilbaYYm
q7oBUVWQ0a+YnDMWy9pBRYTwXyx5wTUIXIMUZW8+KtJKmVKmEJ/Qlo8e/9XcVypZ
IcXGpxFKpZQ0TV2WlbEw0tU4Y66sxXkJflRieOHNgmH1I1uwPrdnBi3yJsVoJFa/
fwhaOA3H9ze2apzASy1wZ3APS/F4Qwph0bbp9pkwtkZeeEaq3WeEgHCyCJUIkkwX
36srqUHsnfnwEQR8Klbhuwyl/Gawg8T+CrD0CRKm79gSxAY0NtQ9SVpO9zcWVegc
ozbMLyLRgaz6On8vqitAj8+ZZq/n0n+o4Hlmz7F411MGn02VBgW10i9IzsX3t4ov
Abjh2IA1Rqba6575ITC9o1ppFmHnmpyrwSjUZWZi8nIqsgZoRfT9ZFRY8k+2K8Zf
Z02nmcQ3ZZdX6YFZHNRQFg3JLO+S3nziwDa6Dfz+gWFOo2DhFCQVNl54XT3hv3P2
AHojiF3Nd1qh1VEPW8NrUl2e9Axe/q1GIBi2wnEO9inYAR162E2eHBYfAIrHAr8h
Qtv2A0I7E++/7GnfduPp2UGh38uUNmF4LrBQK7kqoCEd+y2jrBfZ0tLkaK7mdNiX
Y7FOtsu3Pae5UWHiwSORIZW01K5KvScz8uM4kHWc9OasBhYuw/Fq22TtUq8yYMol
Xkqy98IdZO77qMlc/oOH
=H38M
-----END PGP SIGNATURE-----

--9BeBre8NBj4DEi7b3HJVr1MXlbLm8MeL0--
