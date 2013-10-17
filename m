Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3JQUZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:25:38 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35362 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762524Ab3JQUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:25:37 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: Add hci_h4p driver
Date: Thu, 17 Oct 2013 22:25:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3728288.q054zeFcxh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310172225.33343@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3728288.q054zeFcxh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 20 September 2013 21:01:50 Pali Roh=C3=A1r wrote:
> From: Ville Tervo <ville.tervo@nokia.com>
>=20
> This driver adding support for Nokia N900 bluetooth hardware
>=20
> Signed-off-by: Ville Tervo <ville.tervo@nokia.com>
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/bluetooth/Kconfig             |   10 +
>  drivers/bluetooth/Makefile            |    2 +
>  drivers/bluetooth/hci_h4p/Makefile    |    7 +
>  drivers/bluetooth/hci_h4p/core.c      | 1085
> +++++++++++++++++++++++++++++++++
> drivers/bluetooth/hci_h4p/fw-bcm.c    |  149 +++++
>  drivers/bluetooth/hci_h4p/fw-csr.c    |  152 +++++
>  drivers/bluetooth/hci_h4p/fw-ti1273.c |  113 ++++
>  drivers/bluetooth/hci_h4p/fw.c        |  166 +++++
>  drivers/bluetooth/hci_h4p/hci_h4p.h   |  238 ++++++++
>  drivers/bluetooth/hci_h4p/uart.c      |  203 ++++++
>  include/linux/bluetooth/hci_h4p.h     |   41 ++
>  11 files changed, 2166 insertions(+)
>  create mode 100644 drivers/bluetooth/hci_h4p/Makefile
>  create mode 100644 drivers/bluetooth/hci_h4p/core.c
>  create mode 100644 drivers/bluetooth/hci_h4p/fw-bcm.c
>  create mode 100644 drivers/bluetooth/hci_h4p/fw-csr.c
>  create mode 100644 drivers/bluetooth/hci_h4p/fw-ti1273.c
>  create mode 100644 drivers/bluetooth/hci_h4p/fw.c
>  create mode 100644 drivers/bluetooth/hci_h4p/hci_h4p.h
>  create mode 100644 drivers/bluetooth/hci_h4p/uart.c
>  create mode 100644 include/linux/bluetooth/hci_h4p.h
>=20

Can somebody look & comment this patch? What is needed to be part=20
of upstream kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3728288.q054zeFcxh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJgR70ACgkQi/DJPQPkQ1LypQCfaZR4KQO4zfn5IVL8ZZH1p+rb
dkEAniyMDWBvcfUJHepYkWWYtVZ/iJrg
=NKgj
-----END PGP SIGNATURE-----

--nextPart3728288.q054zeFcxh--
