Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3CBWXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:23:12 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47760 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3CBWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:23:10 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
Date: Sat, 2 Mar 2013 23:23:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-26-generic; KDE/4.10.0; x86_64; ; )
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Kyle Manna <kyle@kylemanna.com>
References: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5018920.2FXvFFs7yz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303022323.06091@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5018920.2FXvFFs7yz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 15 February 2013 23:56:49 Pali Roh=C3=A1r wrote:
> Driver twl4030-madc has hardcoded channel types (10 - battery
> current, 1 - battery temperature) and also conversation data
> in variable twl4030_divider_ratios. These hardcoded channels
> are incorrect for Nokia RX-51 board (where is channel 0 -
> battery temperature).
>=20
> For Nokia RX-51 there is rx51_battery power_supply driver
> which reporting battery information via
> twl4030_madc_conversion. But this driver needs raw values
> (not converted via some hardcoded functions). So this patch
> adding new parameter "raw" to struct twl4030_madc_request
> which tell twl4030-madc driver to not convert values, but
> rather return raw.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
>  include/linux/i2c/twl4030-madc.h |    2 ++
>  2 files changed, 12 insertions(+), 4 deletions(-)
>=20

Hello, can somebody review this twl4030-madc patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5018920.2FXvFFs7yz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlEye8oACgkQi/DJPQPkQ1LLLACgiJQsZAdFu9PpViZqrSnHI+xn
UdYAnRUDBswOTA+QJIApWxrFZhaHjbVB
=FbMh
-----END PGP SIGNATURE-----

--nextPart5018920.2FXvFFs7yz--
