Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3L3Ny5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:54:57 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59808 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3L3Nyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:54:55 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Date: Mon, 30 Dec 2013 14:54:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com> <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org> <20131230121350.GB31236@amd.pavel.ucw.cz>
In-Reply-To: <20131230121350.GB31236@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1836865.HXRv868oZn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312301454.51096@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1836865.HXRv868oZn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 30 December 2013 13:13:50 Pavel Machek wrote:
> > > +
> > > +	if (not_valid) {
> > > +		dev_info(info->dev, "Valid bluetooth address not=20
found,
> > > setting some random\n"); +		/* When address is not valid,
> > > use some random but Nokia MAC */ +		memcpy(info-
>bd_addr,
> > > nokia_oui, 3);
> > > +		get_random_bytes(info->bd_addr + 3, 3);
> > > +	}
> >=20
> > This behavior is extremely dangerous. I would rather have
> > the device init or powering on the device fail instead of
> > making up a number that might clash with a real Nokia
> > device.
>=20
> Perhaps people can donate bt addresses from their
> no-longer-functional bluetooth devices and we can select from
> such pool here? ;-).
>=20
> Is there some experimental range we can allocate from?
>=20

Wifi driver wl1251 (it is already in mainline) is doing same:=20
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/driver=
s/net/wireless/ti/wl1251/main.c#n1431

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart1836865.HXRv868oZn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLBeycACgkQi/DJPQPkQ1IlUACaAmpBaeylZYc0Zr3uMiTZOFQl
gKcAnR/ETx1+3TLn8xM0o5z1v4aKRQJ6
=hJZ3
-----END PGP SIGNATURE-----

--nextPart1836865.HXRv868oZn--
