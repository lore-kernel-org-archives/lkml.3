Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaJVHDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:03:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45739 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJVHDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:03:05 -0400
Message-ID: <54475688.3090902@ti.com>
Date: Wed, 22 Oct 2014 10:02:32 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: video: fbdev: atmel_lcdfb.c: remove unnecessary
 header
References: <1413548355-499-1-git-send-email-alexandre.belloni@free-electrons.com> <5444FE2E.6030509@atmel.com>
In-Reply-To: <5444FE2E.6030509@atmel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="JfDdJEsOJUsSskD1fKJVInRgdE5n9EOu7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JfDdJEsOJUsSskD1fKJVInRgdE5n9EOu7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 20/10/14 15:21, Nicolas Ferre wrote:
> On 17/10/2014 14:19, Alexandre Belloni :
>> Remove unnecessary mach/cpu.h header to be able to converge to a multi=
platform
>> kernel.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com=
>
>=20
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Thanks.
>=20
> Tomi, can you take it?

Thanks, queued for 3.18 fixes.

 Tomi




--JfDdJEsOJUsSskD1fKJVInRgdE5n9EOu7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUR1aIAAoJEPo9qoy8lh71JLkQAIpD2m1Xb7+RUIdVD/eXGN9W
E9sl/hk9WPGSH+QhqmiImw6qJb8FPk2M+KqNFgFtmFjm7Eus8aJ6xvM3q4kgVC7U
KEIZsIZ/qFQ7YBCLRc0kLjcvPJK8SCrEGvPpkpxfWOIRKTg6Ii9IlsF20SY79um0
AMkpToq8GAgQmDg14cuH+hGYexzDvYMkqVBW5YZVmUGy1IoLD7qbkapyxuOPq1vF
VAHGeMvPwJhmwAQ7PTtpx80aqLfIolRTZxPqZF1h+TC0q6YibdFJHe1fcIRw1gVT
pytqZCNgwFOGLwhBi1i2hJ7M0hkmwUFkwaU2Geo1WeRei481IFJUHEPfZiTbBhO7
f9nT1auKMvRj/bJ0q3RoG7wU7JaeEImEs7PxHPV3vBn4HLjRdyH1jHg1acfwI5ad
u+NpPcEOZzZZWX53E/aocUjJKNxP4UwP95iguiKbTvyKRITOBk82OZTJHwlTe5D4
ZLTaBK3NARl2XSzRi9sRHzolPW4TVRkT5i3Z3H7PNdXvjoxM/WWosAa91O4G5Llf
bXuC57YnXYBkVXZ91Lfpi+v9B7Yhn5HP8387a91zxibzh+32iS6ewLAnKnv9FsqS
XQaV1gSTzDtnq6H1kf1LOMXYXhx1ZgHJkhf2mvIeGfeAdM1rwRB+KPTk9NQSmxXf
3L5zJhYwdhUfRMqN4eMG
=k+tx
-----END PGP SIGNATURE-----

--JfDdJEsOJUsSskD1fKJVInRgdE5n9EOu7--
