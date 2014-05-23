Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaEWJwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:52:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:38407 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaEWJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:51:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,892,1392192000"; 
   d="asc'?scan'208";a="435987812"
Message-ID: <1400838717.22900.15.camel@jtkirshe-mobl>
Subject: Re: [PATCH] e1000: Use time_after() for time comparison
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Fri, 23 May 2014 02:51:57 -0700
In-Reply-To: <1400790090-13404-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400790090-13404-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HaQsRa+32cPkwJvZucNt"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HaQsRa+32cPkwJvZucNt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-05-22 at 22:21 +0200, Manuel Sch=C3=B6lling wrote:
> To be future-proof and for better readability the time comparisons are
> modified
> to use time_after() instead of plain, error-prone math.
>=20
> Signed-off-by: Manuel Sch=C3=B6lling <manuel.schoelling@gmx.de>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks Manuel, I have added your patch to my queue.

--=-HaQsRa+32cPkwJvZucNt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJTfxo9AAoJEOVv75VaS+3O5PkQAJc4NGbzhUIjTY550VNmtnqw
4/Pqb8qumD13ddMXf2GCOEo9mVk04BoovNuYMaLJliEwB0YVeH5L9eZX36Zf1dIZ
aMGaijx526e/SyhvIxWz3XIsyphCUsdDXWtl5bzE296xdbs+ViRw17d0fJ118chu
Dol7NICU28ULZg8HahcqJUnj2DY9SgX4xMbFF+u1efkR2iwPg0I7dWEWZa4q98av
ge/PlpNHw99DW/6A+FfnGUObsk9ZAaZTdpPieeCSenltMQabcPtmwFaqqvTn09Md
5GAusKKFgQdZm0kI7/CkVW+AmQcxb8Y+CjTqUp72dT/r3sARZm+gJX2SiN7SH3XU
9CcOvvrMvPQBG8a7gCDVLcaSDUckPd1+8W3YZavN+HNUX+obLIujcz8j49Jho+mw
hZwseez1zIaTBHq3xICZtGNhe1VFLd1jll/5GZ4YR6XzkT0BRA2KW+vWod33BMGo
lO7VhYQBhSnIysNjWgs1dpZGKSBtlDEAWsfU++Kk7apNkla22jiexoxEdStbtfjE
IpD7Q+lzxlHijpA3iqOBjjrCPxBoflm+wttzY4S8F+QA1qmr799JwiibHSQN4vJm
dP022h+jxRIf8Yn85ucCH0zBUGicITZ89huwVwwAy9SqV6SEe7MvMZn/iVwFOTU4
vayuBnZy8r6/M1bDJBTQ
=dgsY
-----END PGP SIGNATURE-----

--=-HaQsRa+32cPkwJvZucNt--

