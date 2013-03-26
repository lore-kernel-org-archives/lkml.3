Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3CZT1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:27:45 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59957 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CZT1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:27:43 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] power: bq27x00_battery: Export all battery registers via sysfs
Date: Tue, 26 Mar 2013 20:27:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com> <50FBBE7D.7040102@metafoo.de>
In-Reply-To: <50FBBE7D.7040102@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1383669.5qPOGqsyJq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303262027.39772@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1383669.5qPOGqsyJq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 20 January 2013 10:53:01 Lars-Peter Clausen wrote:
> On 01/19/2013 03:01 PM, Pali Roh=C3=A1r wrote:
> > bq27xxx batteries have a lot of properties, more than
> > power_supply interface. Some of them can be usefull for
> > userspace applications (like CI bit) but does not make
> > sense to add bq specified property to power_supply
> > interface. When bq27x00_battery is not loaded userspace
> > application (like i2cget) can use /dev/i2c-* interface for
> > raw access. But when kernel module is attached to i2c
> > device, userspace applications cannot access it via
> > /dev/i2c-*.
>=20
> You can still access it if you use the I2C_SLAVE_FORCE flag.
> This is a bit ugly, but I'd rather see an ugly hack in
> userspace than in kernel space.
>=20

What is I2C_SLAVE_FORCE flag doing? Isnt there some potential=20
hardware damage problems (like simultaneous access to i2c bus)?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1383669.5qPOGqsyJq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFR9qsACgkQi/DJPQPkQ1KyWgCguQu7ym7uGgVnSP2e3H8fkM9W
1dQAoJQYCza1Ib7Xv+aRGTpzEYk5rehk
=kWkP
-----END PGP SIGNATURE-----

--nextPart1383669.5qPOGqsyJq--
