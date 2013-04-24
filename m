Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3DXHm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:42:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3DXHmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:24 -0400
Date: Wed, 24 Apr 2013 09:41:58 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, tbergstrom@nvidia.com,
        amerilainen@nvidia.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH -next v3] gpu: host1x: gr2d: fix error return code in
 gr2d_submit()
Message-ID: <20130424074158.GB2833@avionic-0098.mockup.avionic-design.de>
References: <CAPgLHd8cEvvxnRYK3H6FbykXsiyHRWFxV2LtSyayzp2gNejhFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <CAPgLHd8cEvvxnRYK3H6FbykXsiyHRWFxV2LtSyayzp2gNejhFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:AOs5ih94ykUfhHwxRpwmG9BTDp4nPzbXCLLcwVYzVH/
 BGNIawacCFCJLLUNEL8G4F5pncQe1J0Zu2G9evMjqAu3JuAx1u
 MbSQX/q9WoepDnM7TK/o5dift2jc6ddsrG6MdgnJ/SD6b1wsi6
 zuSM3cDoTGHKVznoAe0jMwou6jk/uL4i8bAs2ftrXfgkt7q7Lv
 HOVGiiATTHH9fijXXlED/AhdnGZQxUVwcFSE/LFSfeNfnxhjnc
 Xfo+oDg8qTOQ5gx+0I5YvsQuu8hIC11xQdJqTZEGAj1Tw61Lfw
 kH8Xv6xT6CBwu5g0pyPY1Q7g4HdQH1zrsVwu01uNs3hn/EgNff
 Ft44vomVWHKz0oawcKPdWIEgUXzWN4iKd3/oW58QEjP1ljmhW6
 o+4q+M6nD3fFMtT1sgSHLD7ivxIoAXvIMVOw4lKWMzMZNZfVit
 KO6JR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2013 at 02:50:51PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fix to return -ENOENT in the host1x_bo lookup error handling
> case instead of 0, as done elsewhere in this function.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

I've applied this to my fixes branch with the same modifications as for
the other patch.

Thanks,
Thierry

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRd4zGAAoJEN0jrNd/PrOhiOwQAKTXH6i7p1rOqZoYUcuYKVaO
swvU9nyttTRn70UGLcYKSd5TtYYDIjjMYBjTfaO6d/O04Uss0DPAS2cD+mhjNgcf
YNHZTGTtTLuzAJA7sSu/xPEXuWtNh+z0EbZcdbmSfAHYihhOvSjhdNkXjEPsDNuP
Q2TI9wI5SCRKtS82egpYtesCBeIMq04enuXNw59TRUIMDvpRqRJ46oGnjsXY0YeV
NFstSKwYTCszle+DHsK5wy6APpvyGO8X/X3IdYSznOQDZ1yD6AiVqOFB87EeMiFl
cel72CSaRw17pspSMUsnwcOHLvO/muKW5Ad2Qci+Jx5ILjSqV/UuGhXxmD6014bu
7riBxYH6A0t06jnjDFqZAaCoUuiQ9FHqpQc550DY7PdFYYm/hMtnTrpXfjjZ0yIk
8A/va1gVB0dT9m21TAbmOPWaEnEuY6tAnUARbVULbqHrbnKzC0cSNlxSoJxQhjwq
ZOcgAhahNufaq7S6ofGD3kA9NlyRCUBD8JQhiq36hf4TluhUKtAYJnlKyUnQZGH5
gSx2bEcLGHkBi4u+qEjPot7oq9qwJBBzQ8fkIiVExhiEQIb3ND3GwCIsxci/VIHi
kOfpaZpMMHGelxKHd1CO8/nE0FfrCfjURoX3Fguv28Pxtfu/Jh7tBFN29C0r0Top
uwdkaRKia3MLTSGTUrG0
=tkHf
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
