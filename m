Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3AONqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:46:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:21156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab3AONqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:46:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="asc'?scan'208";a="244127502"
Message-ID: <1358257677.2731.141.camel@sauron.fi.intel.com>
Subject: Re: [PATCH -v2 17/26] mtd: rename random32() to prandom_u32()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Tue, 15 Jan 2013 15:47:57 +0200
In-Reply-To: <1357215562-6288-18-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
	 <1357215562-6288-18-git-send-email-akinobu.mita@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qKbVCtNnQRi42NKfPLwE"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qKbVCtNnQRi42NKfPLwE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-03 at 21:19 +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Pushed to l2-mtd.git, thanks!=20

--=20
Best Regards,
Artem Bityutskiy

--=-qKbVCtNnQRi42NKfPLwE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ9V4NAAoJECmIfjd9wqK0WtgQAKcSD2qAF8pDUvO1bRwg9S4B
i72IVOdKhd9mx8KOuklaDK7knxvOBKJ7uxT5wZmF+s1+MQ9VandfKihcf6t8xzRl
BFKY0QwrVJLy8R4y0EO/RSFM/Pm6DKjfrIKtwHIPmlQf7/TjCeyqkLQ/o/fGbanr
8FuRWOAalzJHavpumU3imhvLF899oDWDCUxxxtBPGFS1Rd0XlJTtbCzo4CUrrWvB
5wEKOKgIZGewmeWYCwX+tPgdI5qv4LiiaRLXbyj2xFQiEpHphBTAtbz1R5Fx0D/W
rdZR5kgF8OEV61zlfXSBwdP1ums4wVomEahWOEUz6GAOMRqyMrOzfWcgkhJa82cs
qbkDu9YzV7SKxtnDx3UxnnRH4rmiEyAuWd7oXDyqMb+Xxjg5u3IVgURG4MQpfbO+
GqU9VsOSCGSN6oOMz91EzShOVw3S2aHSetxBKJrO3i7M5Ap7sbWlZ5DIo6FF5Sgm
q18L2uE0BHT8vSqTvhbxLqa1PcNvliOtXLXr2cP/rR1zuFalG/4GLFtil+hdNDzV
JXQdgwACJS2Z15wthLPv6vBMugS7Q7DYQpmsv2846UJ/TCatvrZ+XqriKu6hvbAw
S3FnGCj27lCB6LTlnEsNyo6uWoeLLXnLEk3fyxYgTY/7ANNx/zk5hum63kV0xcXg
s0ai2QKa1Eyf1MymIqZ3
=S/Cf
-----END PGP SIGNATURE-----

--=-qKbVCtNnQRi42NKfPLwE--

