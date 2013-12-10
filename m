Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3LJRIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:08:51 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49213 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3LJRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:08:49 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@adurom.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
Date: Tue, 10 Dec 2013 18:08:44 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com> <20131210092114.GB22756@amd.pavel.ucw.cz> <8738m0r9wv.fsf@purkki.adurom.net>
In-Reply-To: <8738m0r9wv.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1950882.g5FqhQI21j";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312101808.44713@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1950882.g5FqhQI21j
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 10 December 2013 16:41:04 Kalle Valo wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> > ssids can have \0s in them... and what is worse, they may
> > not be 0 terminated AFAICT.
> >=20
> > Potential solution is at
> > http://www.spinics.net/lists/linux-wireless/msg98640.html .
>=20
> I just use print_hex_dump_bytes() to print SSIDs.

Ok and has kernel printf modifier for size_t?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1950882.g5FqhQI21j
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKnSpwACgkQi/DJPQPkQ1L9pQCgjFc7/1zXxMNs6AWKB6PogyxB
v9MAoIMHpQbRIy/N2p6/y3ViuvDYtIcf
=/Nzb
-----END PGP SIGNATURE-----

--nextPart1950882.g5FqhQI21j--
