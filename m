Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaEWKwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:52:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38745 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaEWKwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:52:09 -0400
Message-ID: <537F2848.5070500@ti.com>
Date: Fri, 23 May 2014 13:51:52 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <sunzc522@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <gxt@mprc.pku.edu.cn>,
        <gang.chen.5i5j@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] drivers/video/fbdev/fb-puv3.c: Add header files for function
 unifb_mmap
References: <1400652811-5206-1-git-send-email-sunzc522@gmail.com>
In-Reply-To: <1400652811-5206-1-git-send-email-sunzc522@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="eNjH7Fded4gXScbLmsorx48tESEKLvMgU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eNjH7Fded4gXScbLmsorx48tESEKLvMgU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/05/14 09:13, sunzc522@gmail.com wrote:
> From: Zhichuang SUN <sunzc522@gmail.com>
>=20
> Function unifb_mmap calls functions which are defined in linux/mm.h
> and asm/pgtable.h
>=20
> The related error (for unicore32 with unicore32_defconfig):
> 	CC      drivers/video/fbdev/fb-puv3.o
> 	drivers/video/fbdev/fb-puv3.c: In function 'unifb_mmap':
> 	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
> 				      function 'vm_iomap_memory'
> 	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
> 				      function 'pgprot_noncached'
>=20

Thanks, queued for 3.16.

 Tomi



--eNjH7Fded4gXScbLmsorx48tESEKLvMgU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfyhIAAoJEPo9qoy8lh71lS0P/2g8xXwaWEJzTNSdEW5DV3SJ
XXWC5dQRd2wbAQYM8RQFCoWjQlaaFPX3aZ1rS0zkis8cIKfDpg2aCDCkXPCwM9Fp
ForhE6pD4EsqJKherZgm3kNC/L+I6u7E3mOmkczgfsrHBKJ5AyfCZL3tolfJATrL
JZOeInbh9TEN9mZiUPyOLGu+mdDywzgw4JXzQY9ZlPcVsiiX9k6UjOdo9W+k4qLn
3WPPZDJAkjUtngrHnd/fPYfd0dBS99R7+qXEQ6ZFyI4F6mf5okv+B5wQdMg7uIOD
Iq+G7Nhdm83CrCJdoxnyEkBmp12GVnxXv0MBmQaIvqq+GYG6BB051DPfbPHFkMnE
U1wgBax2BRCBgTq5A35bfknaYBn+jA+fZscqOKxyunyrgA7otUX1JgSjfvnL+Ayx
+Ks2gpxMUUUkQU7dHQTJPnlzgn5LRhDkKoTndOKVOhQqWam341PGuAN8uGiFsYfV
eymWrprrpiqLzYHroGBGJNSpXeD57JkZ6g8qBNLUPr/g9vXgqt5XP/x8//UjCB67
ketJy8yq4BA3aDNwJRITe1Wzmhp3AEDJk9qAQz/RGPwk+d29iqsg/NR1mhAbg3GC
B3/5TdLCaYvLZ/5T8x/GKewKd5CqB4sfK92qBhygvE3niCXxQQfiCzumi8y6ylZ0
Os93iWTtbT5+7nyQtTO+
=FN47
-----END PGP SIGNATURE-----

--eNjH7Fded4gXScbLmsorx48tESEKLvMgU--
