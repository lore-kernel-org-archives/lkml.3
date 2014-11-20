Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaKTMAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:00:05 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:62516 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaKTMAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:00:01 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Thu, 20 Nov 2014 11:59:59 +0000
Message-ID: <546DD7B7.3070408@imgtec.com>
Date: Thu, 20 Nov 2014 11:59:51 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>,
        <linux-metag@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH 01/15] clk: divider: replace bitfield width with mask
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com> <1416438943-11429-2-git-send-email-james.hogan@imgtec.com> <546DCE53.8020004@ti.com>
In-Reply-To: <546DCE53.8020004@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="3ECPGSX0RDXLFldwTNVnnLIWWLTDQlT6G"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: f2c42831
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3ECPGSX0RDXLFldwTNVnnLIWWLTDQlT6G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20/11/14 11:19, Tero Kristo wrote:
> On 11/20/2014 01:15 AM, James Hogan wrote:
>> - Updated assignment of clk_divider::width in imx, rockchip, st, sunxi=
,
>>    ti clock components to use mask instead (not tested), using the
>>    following semantic patch:
>=20
> Hi James/Mike,
>=20
> This patch currently causes a build breakage with omap2plus_defconfig.
> Reason being you are modifying the clk_divider struct, but not touching=

> the code under drivers/clk/ti/divider.c which uses it. The fixes are
> basically the same you have done for clk-divider.c, the contents of thi=
s
> file are mostly just copied under TI clock driver.

Thanks for pointing that out! I'll fix and improve my grep-fu to find
other such cases.

Cheers
James


--3ECPGSX0RDXLFldwTNVnnLIWWLTDQlT6G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUbde+AAoJEGwLaZPeOHZ6MuUQAJxW+C52BeSeukxmk6+p+CJG
z/ww0Y3o6b/XUJnQARxHvkkDX/Kh/YKAtQSoySSgTOceeZHHPsDD7mHMZvCk9Av3
yV9p8agyWUZ756OA9KFYBODaE8whAxExZBOEG550ZWlbeHXQpyqdYTWGyY6NaITC
9jc8zq+2BomJaYhCWO29X+GW/xcetAYhtOBpf2IPw17E3JNSS2KTizvvzjzZz+17
z2LV8LyaYhzMgeSiZcFh7z6QZMI+qY8ZArgZRP95KW91l2oeFjzmhWzO3gZUqg4o
/f8qWD+Z9zV2coKZvPPiie0r3s8mzxA6pxq/OUtrDaSX2sghuugWY7fGnHjOwH7c
MYztsc9UDIGNp3JEhUOps5gKM0slauvavDCzrY3Y9+5HGlwplGZkAJJAZEGn9Ln1
dm4CkEeTC8oKgaJYD6zgS0k9squZZZY1cL+XgMxX6vywitsL6JIpHYwJzs3/a1JA
wZIOl589UNoOLYt0JRtJ8ANG8JIylEhuLPwePJ5CrvD6x9A49my/pp9VwoRtyEiM
ouiDlL4ZVAHisX2VYFO/hKJ61OGXr52Oiw1lhkBaDGHc9ZRwS4KSbYvBJoBr1E36
671Vms+ggm3gGgmtgcdwUMla9WtLGLl8txOCMT862SA/GY/uuxKUmwzx1dxf2cjY
vd8AXLD4GY7fpDhcqg5W
=QhCs
-----END PGP SIGNATURE-----

--3ECPGSX0RDXLFldwTNVnnLIWWLTDQlT6G--
