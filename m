Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3CJWjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:39:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:39:45 -0400
Date: Sun, 10 Mar 2013 23:39:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 2/5] ARM: DT: tegra114: Add i2c controller DT entry
Message-ID: <20130310223936.GF4743@avionic-0098.mockup.avionic-design.de>
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
 <1362852678-13421-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Content-Disposition: inline
In-Reply-To: <1362852678-13421-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:UMso3trby6GNc2xBI6HXUH7z+HT2GviJt8XMxhhEfra
 Gz3LFFjY64t//P62ySpukXcgRzSTBpRbm7HaR8j5FER61Rafpz
 +8emHQJrfX453gPQfxR7+dIbsejg4neaxCftJl9CiAIn4YbyK9
 mg2w74Q9hHVcrvm47gv8oUuS+id0ivxdE8ypogZvJygqAgKEyO
 zcdRAmKHLgjeI8WMvG4jHwhl8LRMroXVthLNxDN9WgqDFbQkI5
 RO4070/t3eD2g2MNfxX+cSNbQrgTvFAC6f82Ps0adzYZTc7j9D
 49qpQAibwau0ckBjNma+uSzM9N3VoqlYjtM3YP6OakZl/9AZ6o
 TPh3oe+uPnSGOzZEgpSP7vGTL3MrVp1lDeHm4VssIiXhs3PRaR
 XQf9qYp7xzhvL4Wz/RO80vg34iCLL6CEPA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:41:15PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 5 i2c controllers. These controllers have
> additional feature/configurations to make it functional over
> Tegra30's i2c controller driver.
>=20
> Add DT entry for i2c controllers and make it compatible with
> "nvidia,tegra114-i2c".

Both the subject and description should probably use I2C instead of i2c.
Also I don't understand what "make it functional over" means. Perhaps,
since the entries aren't marked compatible with nvidia,tegra30-i2c you
meant to say that they are incompatible with Tegra30?

Thierry

--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQuoAAoJEN0jrNd/PrOh8XQQAJbqkhIafoQ5nFE8DdE4Oz8Q
sq4WpAkEsYbOSQ2KB31yDqbttkFOEzphY4ooEN5ypUqGvk4v5mdfbtbPQkGopQ6a
IWiMym9g47KJNmolABAWixFCYFySyOiFQqRgOvlNtmR+0aG9+aSvzGYWBH4+SyKD
lj0KHj165VLsRg4DY5fAcyNNlNYsqXrJXpL3xcrDw9jW3pr6GjVnPPw/bXzW2T7n
3KU+U4wcfbIf8qNNbpO8Or+FqtKJtQbn/KNm1zeiJ4U1XLzE9kxiGY7RZkFu+NcV
b4u1wpL2FfUVwV3QeF8molVEiWvB8nwlyZ6YJME3NJYx6+dJesnkojypTXrMbYzP
B5yt7/ITd4z7HeAt/XonP5LAPHnDPilsHkPwYJbys+1Hwm7aVNltvvDZ3cX4Cgcq
8knCzLgCvURjdc1hcw3MsSfJ0//I82msp7SjEE8qrqTWJP37Wea9JoSGPB+kU/3h
Zkjxs0cLWn5PFaKGOl6PIsdBFKMjmOGeWfG4j7GulWEMqoYpjZz9d2UT5BspGCnt
HZUH6m3NIbTtfw7fhfwllKKrfE+mq/6gRTrUq9rsIz7SgkIehdZhN9IRGfwoze7R
RiNsRgJR0Ceukau6qlzL6QSNdksobtPnJj/HRNDwlpsC/hp8EM1JzlMMCy63hOPN
Q2ikQF2hgaiISsDtxGmp
=a+4Y
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--
