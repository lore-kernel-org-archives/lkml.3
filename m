Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3DVD4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:56:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47831 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab3DVD4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:56:43 -0400
Message-ID: <1366602998.3408.146.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 66/72] mtdchar: fix offset overflow detection
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 22 Apr 2013 04:56:38 +0100
In-Reply-To: <1366276617-3553-67-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
	 <1366276617-3553-67-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mz7T63a4EFg2LYpGV3Jh"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mz7T63a4EFg2LYpGV3Jh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-04-18 at 10:16 +0100, Luis Henriques wrote:
> 3.5.7.11 -stable review patch.  If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> commit 9c603e53d380459fb62fec7cd085acb0b74ac18f upstream.
[...]

There are further problems with mtdchar_mmap(), and David recommended to
apply commit f5cf8f07423b 'mtd: Disable mtdchar mmap on MMU systems'
instead.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-mz7T63a4EFg2LYpGV3Jh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXS09ue/yOyVhhEJAQqKFg//bkUz7bcGEN7U4CZBE+Yh/2rqurV7mIZ3
4CPfQaiShiEQWH6xExxGVHxo2hj5DeTmlOsgP92noeMkjoagJZUIasPYlRCcbFhR
xIqYa8NUsmuBRtRznibAZ/N+ReJolk4C6AYEkVFb8DjiwpYTO71bw/bX/sbArCzm
Q/0d2or3a+DOZI92KYJ4N2qd6shPyxdh0H/3DSsnMU6VZX88WQYLrXp2YYzYmzoG
+klckd5YndH5B+WoQLuvLMj78dzSLxD6uI7MXgWOxFzVMxe1ALwZT7HJ4Ryp8y4q
+oyezvDNJR+4WPe18yYGH/Gh0RkdkojoLg5Z4KHDu4/FzM6Vv3c5F9vSnxqLB+p9
5FOtJJ22g42Gs9eLjCnCNt7OngUsDwC3WFVHhy5VUwKLaFlv5hcIuLHn79tkc8UA
+g3Nev5xMr0FhULKQn2hODY9pVH7beRdMmFyX/4TyV7ODBdpIys/MQWr9ft0ZGdB
Zi7T13mRi9GvSlasM1h/Y0Fm9MEP1sLJOebH1Sn4zazVvP/xMqU0LpaSS5wkej0F
5jxpHq/8yQ8TodBIbjAwbj7R5+VcniRiWHuYVPifpTCgC/Qpx6hE/rfiN90hwYa0
5DOxUhlHeUF0hIezOfj3NdcGIL7JPXGve6g3mhu+a6PjHPqFdhz1UmE/Q9ei5vMM
QZZq3JFKBic=
=Ww1M
-----END PGP SIGNATURE-----

--=-mz7T63a4EFg2LYpGV3Jh--
