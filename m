Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab3K0VQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:16:52 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:55614 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3K0VQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:16:51 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Wed, 27 Nov 2013 22:16:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        pavel@ucw.cz, anton@enomsg.org, dwmw2@infradead.org, tony@atomide.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
References: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg> <20131125214959.GA20107@earth.universe>
In-Reply-To: <20131125214959.GA20107@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1505224.1dOuLHziek";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311272216.47390@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1505224.1dOuLHziek
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 25 November 2013 22:50:01 Sebastian Reichel wrote:
> > 2 seems more generic to me, but as rx51-battery is missing
> > the functionality to send events on temperature change, I
> > guess 1 will be easier to implement.
>=20
> The temperature must be polled anyway, if the ADC does not
> support interrupts.
>=20

Yes, ADC does not support interrupts, temperature must be polled.=20
Also bq27200 chip does not support interrupts, but=20
bq27x00_battery driver using delayed work which every 60s poll=20
all values (timeout can be configured via modprobe param). So=20
similar code can be added to rx51_battery.ko too.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1505224.1dOuLHziek
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKWYT8ACgkQi/DJPQPkQ1LrDgCZATle/AQn2Md0cNnVsMePRTQ2
prIAn0TgIHG3nOoN2G0SDi2Yggzlaq2Y
=K7Mw
-----END PGP SIGNATURE-----

--nextPart1505224.1dOuLHziek--
