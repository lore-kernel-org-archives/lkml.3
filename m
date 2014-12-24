Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaLXSmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:42:02 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40605 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaLXSmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:42:00 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: 3.19-rc1 refuse connection from bluetooth headset
Date: Wed, 24 Dec 2014 19:41:56 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201412241815.12922@pali> <201412241932.27264@pali> <20141224183737.GA21428@t440s.P-661HNU-DI-F1>
In-Reply-To: <20141224183737.GA21428@t440s.P-661HNU-DI-F1>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1959944.AX0SG6UqHj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412241941.56927@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1959944.AX0SG6UqHj
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 December 2014 19:37:37 Johan Hedberg wrote:
> Hi Pali,
>=20
> On Wed, Dec 24, 2014, Pali Roh=C3=A1r wrote:
> > > Could you try the attached patch? I think the reason might
> > > be the dependence on the HCI_CONNECTABLE flag that's only
> > > set if the page scan was enabled through mgmt (which
> > > wouldn't be the case with BlueZ 4.98).
> > >=20
> > > Johan
> >=20
> > Hi Johan! Thanks for quick reply. Your patch fixes my
> > problem and auto-connection of my bluetooth headset is
> > working again. Will you forward patch to mainline kernel?
>=20
> Yes, we'll tag it from 3.17.x onwards where this was
> introduced.
>=20
> Johan

Ok, you can add my Tested-by line to patch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1959944.AX0SG6UqHj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbCPQACgkQi/DJPQPkQ1Jg6QCfaZmrmjgc3QwkK7tVFInudI5u
qEcAoLOkSLUGuewSOrq0HK1nllcZ/8ZS
=0fOA
-----END PGP SIGNATURE-----

--nextPart1959944.AX0SG6UqHj--
