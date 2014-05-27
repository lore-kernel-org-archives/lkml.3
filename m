Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaE0JPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:15:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36797 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684AbaE0JPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:15:05 -0400
Date: Tue, 27 May 2014 11:13:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v8 3/3] ARM: sunxi: Add IR controller support in DT on A20
Message-ID: <20140527091337.GJ4730@lukather>
References: <1401056805-2218-1-git-send-email-bay@hackerdom.ru>
 <1401056805-2218-4-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q59ABw34pTSIagmi"
Content-Disposition: inline
In-Reply-To: <1401056805-2218-4-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q59ABw34pTSIagmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 04:26:45AM +0600, Alexander Bersenev wrote:
> This patch adds IR controller in A20 Device-Tree:
> - Two IR devices found in A20 user manual
> - Pins for two devices
> - One IR device physically found on Cubieboard 2
> - One IR device physically found on Cubietruck
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts |  6 ++++++
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts  |  6 ++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi            | 32 +++++++++++++++++++++++=
++++++

I told you numerous times already that I wanted this patch to be split
into at least three of them:
  - One to add the device to the DTSI.
  - One to add the pins
  - and one to enable the devices in the DTS.

Please address this comment.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Q59ABw34pTSIagmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThFdBAAoJEBx+YmzsjxAgVEQP/0SS2UMHhFf2Ma96RSvUCMja
IGjon+ErnFINm9OO7MD53SqSQikxg+wQv/gvJHo+ib2lHxJkj40MhzobSML1oE2+
hcJ3Wknbc3aPZHLJvYl+z0IcA603/CZcdbpH0WP0npB4tNGKpnONHtMBJdDjPmYp
vr01GEg/WMFW6359FY5nVusZbFBUR1aaXxA9fEUQveUGswbnXyIrT3m7j4QV0wqy
EJIflTVFpY2g+LaW8jOCAU1nC5zRB2nOUAWPhNXfmUDIwJS3elNBQ188hC6VlMNI
IyXV3yxa7qSVO38JdZ4vwInLdnNeQyuJpwS8e5VFjx6tJA7qpzo0zMArmpy44Lwg
RRgZYj6GWw8ABgLwxc8oSWOSaCPVwFFT7+poF7mRb9dLxvzzKGL7/hv3GloKiSEu
vB75kiu45oPH0rwbZlfGBVULTS4U+cyI1qq16RqRjM05+jlD0RX80nbHnw5k5CXx
jG7B6nPbS/YQcYntMIDvLrCLQHLGqY8NPR/TxB7CWMP4g6iu/1w+sgNaekiuv6/b
IQxHnyQytsxoeeBqg7Is6kvRM3p1CooJRoppJm3ZSepVgGOGvNpa0rHfS+DhzGHV
V+jLb6eiv5klWN2Z/12pF7MZPmlRVV1nQSYka3tKoMG2PVh/3AmuPU5Qhx8vRUvy
owDjGElsC1Zl7Uk/uRg/
=TAtz
-----END PGP SIGNATURE-----

--Q59ABw34pTSIagmi--
