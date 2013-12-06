Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162675Ab3LFNcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:32:15 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:55820 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161117Ab3LFNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:32:13 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Fri, 6 Dec 2013 14:32:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10426763.o6OPnWeIKB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312061432.09120@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10426763.o6OPnWeIKB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 19 November 2013 11:18:04 Pali Roh=C3=A1r wrote:
> This patch removing set_mode_hook function from board data and
> replacing it with new string variable of notifier power
> supply device. After this change it is possible to add DT
> support because driver does not need specific board function
> anymore. Only static data and name of power supply device is
> required.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/power/bq2415x_charger.c       |   77
> +++++++++++++++++++++++++--------
> include/linux/power/bq2415x_charger.h |   48
> +++----------------- 2 files changed, 65 insertions(+), 60
> deletions(-)
>=20

Hi Anton, is there any problem with this patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10426763.o6OPnWeIKB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKh0dkACgkQi/DJPQPkQ1KyNACeJCZNwvkQRCE7Orj5omrpiiuN
4K0AnRHZe+UkOlkAHRIIHWGW8X8vXY/e
=rBpn
-----END PGP SIGNATURE-----

--nextPart10426763.o6OPnWeIKB--
