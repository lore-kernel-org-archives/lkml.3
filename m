Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3AOOy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:54:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:25308 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AOOyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:54:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="asc'?scan'208";a="244154792"
Message-ID: <1358261750.2731.148.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tony Prisk <linux@prisktech.co.nz>
Cc: David Woodhouse <dwmw2@infradead.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 15 Jan 2013 16:55:50 +0200
In-Reply-To: <1356901207-13536-1-git-send-email-linux@prisktech.co.nz>
References: <1356901207-13536-1-git-send-email-linux@prisktech.co.nz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1mrfJBD60TFdLJ5zAm6a"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1mrfJBD60TFdLJ5zAm6a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-31 at 10:00 +1300, Tony Prisk wrote:
> This patch adds support for the Wondermedia serial flash controller
> found on WM8505, WM8650 and WM8850 SoCs.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2: Whitespace tidyup

Hi, would you please take a look at these warings, identified by aiaiai:

Successfully built configuration "x86_64_defconfig,x86_64,", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/devices/wmt_sflash.c: In function =E2=80=98sf_read=E2=80=99:
+drivers/mtd/devices/wmt_sflash.c:425:9: warning: format =E2=80=98%d=E2=80=
=99 expects argument of type =E2=80=98int=E2=80=99, but argument 4 has type=
 =E2=80=98size_t=E2=80=99 [-Wformat]
+drivers/mtd/devices/wmt_sflash.c: In function =E2=80=98sf_sector_write=E2=
=80=99:
+drivers/mtd/devices/wmt_sflash.c:442:16: warning: cast from pointer to int=
eger of different size [-Wpointer-to-int-cast]
+drivers/mtd/devices/wmt_sflash.c:442:24: warning: cast removes address spa=
ce of expression [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:16: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
+drivers/mtd/devices/wmt_sflash.c:458:31: warning: incorrect type in argume=
nt 1 (different address spaces) [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:31:    expected void volatile [nodere=
f] <asn:2>*dst [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:31:    got unsigned char [usertype] *=
<noident> [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:17: warning: cast to pointer from int=
eger of different size [-Wint-to-pointer-cast]
+drivers/mtd/devices/wmt_sflash.c:465:39: warning: incorrect type in argume=
nt 1 (different address spaces) [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:39:    expected void volatile [nodere=
f] <asn:2>*dst [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:39:    got unsigned char [usertype] *=
<noident> [sparse]

--=20
Best Regards,
Artem Bityutskiy

--=-1mrfJBD60TFdLJ5zAm6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ9W32AAoJECmIfjd9wqK0yg4P/RRDYWiUiei1m+Am2dlLdA43
kCkfiZCmClUznLGZCi1LxcWspwpqA7Cu2IRpKz98K8jfWpNwLjRixmzG4hu/iMfC
+WlQ9o0vJAyBjmu66ToMYHl4GzAl0NYFhhrUflKgZDzgOlTWjNWOiEf1erQHwZf9
teJJOhh2BoLmrbhPDx7WBPFmhaENW0OYYb1hE6AtnU4/c0jnCaXV+Xb0YjstjqA1
GZm9MOJf5Avt8Jaz5IlimR22jmGg2ETqs6biRpZUoQIJnOs9BCNITmlBG1bf1e8I
Ph2SM5dh25jDLqp5FxT4/CFIBNXmVRhZpN7AL7p3iYyTP/tDASZ02H0VZ2/x+uqJ
BphJYAn9aFIwJ7yPqvaczq9xsfbXMt4vbOb6QcoYovJPxhVvY6Ft+UaVHVJmu4dL
loZo4isj7X/09XPfjvi7P/65DkR2sjO4Zm517vyZ1jk4/D4i0KsagNl4E/rbgKme
k/HKbm02F2llVoXMNQ98XMX1rdgi8uBdfumMoW7LRm2cJ85zHb6DNzD6Hvly+hr7
cYyJTpwF8L+ynV+piE2LbrSmsJJPZ7nue0OBvpBwpis5BuaNbOzgryUXl1ipmIrS
VfwsDv0aS3HEfTFZL+yDus2hJnBus8WaXmmPdSsPbCZ2x574rO3+CvSKKl/nWnb/
dvZB9pd9PnwIlfNgEZ/l
=zTUr
-----END PGP SIGNATURE-----

--=-1mrfJBD60TFdLJ5zAm6a--

