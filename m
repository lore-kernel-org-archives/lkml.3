Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbaKQHjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 02:39:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36272 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaKQHjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 02:39:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
Date: Mon, 17 Nov 2014 08:39:14 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <1541270.g199T8YFIC@dtor-glaptop>
In-Reply-To: <1541270.g199T8YFIC@dtor-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1505690.ZvFtjOko4a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411170839.17504@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1505690.ZvFtjOko4a
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 14 November 2014 21:59:31 Dmitry Torokhov wrote:
> Hi Pali,
>=20
> On Friday, November 14, 2014 08:38:19 PM Pali Roh=C3=A1r wrote:
> > This patch series fix detection and identifying trackstick
> > on machines with ALPS devices. Last patch split trackstick
> > and bare PS/2 mouse packets between dev2 and dev3 input
> > devices which make sure that driver will send only
> > trackstick data to trackstick input device.
>=20
> Thank you for splitting the change, unfortunately it is now
> quite big to apply to 3.18. Any chance you could try
> implementing what I suggested in
> http://www.spinics.net/lists/linux-input/msg34029.html and
> then we can do the more comprehensive solution in 3.19.
>=20
> Thanks.

Hello, I think that patches 1/7 and 5/7 could do that job. I did=20
not tested them alone (without other patches), but if you think=20
that two patches are ok for 3.18 & stable I can test them...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1505690.ZvFtjOko4a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRppiUACgkQi/DJPQPkQ1LrcACgzG3l/IjhtScIuy42TJT/EOZp
ztMAoK75GuPVibPe4pR1ZucuzwNQs6pb
=7A4N
-----END PGP SIGNATURE-----

--nextPart1505690.ZvFtjOko4a--
