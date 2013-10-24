Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3JXQlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:41:12 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53019 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3JXQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:41:10 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: Add hci_h4p driver
Date: Thu, 24 Oct 2013 18:41:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <3B0F039C-4680-46FF-A654-48D6A28B9B5E@holtmann.org> <201310181230.45351@pali>
In-Reply-To: <201310181230.45351@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart153643812.pd1H40aPDV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201310241841.05935@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart153643812.pd1H40aPDV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 18 October 2013 12:30:44 Pali Roh=C3=A1r wrote:
>   On Friday 18 October 2013 00:11:44 Marcel Holtmann wrote:
> > Hi Pali,
> >
> >=20
> >
> > >=20
> > >
> > > Can somebody look & comment this patch? What is needed to
> > > be part of upstream kernel?
> >
> >=20
> >
> > you need to rebase against bluetooth-next at least.
> >
> >=20
> >
> > Regards
> >
> >=20
> >
> > Marcel
>=20
> I rebased patch on top of
> https://git.kernel.org/cgit/linux/kernel/git/bluetooth/blueto
> oth-next.git branch master

Hello Marcel, have you looked at hci_h4p patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart153643812.pd1H40aPDV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJpTaEACgkQi/DJPQPkQ1KQtQCgk8Fjta328JqvFo5F9Cte7zcn
k6YAniLhN3J9jA6yx9Wwn8197x+2cZzg
=vjys
-----END PGP SIGNATURE-----

--nextPart153643812.pd1H40aPDV--
