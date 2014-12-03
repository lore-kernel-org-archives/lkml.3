Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaLCK7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:59:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLCK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:59:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
Date: Wed, 3 Dec 2014 11:59:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <201411251208.31658@pali> <DD50BA4C-4E7C-4E69-9A79-52C2B577F580@gmail.com>
In-Reply-To: <DD50BA4C-4E7C-4E69-9A79-52C2B577F580@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10742929.JHqQP31OPD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412031159.12055@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10742929.JHqQP31OPD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 27 November 2014 19:08:04 Dmitry Torokhov wrote:
> On November 25, 2014 3:08:31 AM PST, "Pali Roh=C3=A1r"=20
<pali.rohar@gmail.com> wrote:
> >On Thursday 20 November 2014 00:29:49 Pali Roh=C3=A1r wrote:
> >> On Monday 17 November 2014 08:39:14 Pali Roh=C3=A1r wrote:
> >> > On Friday 14 November 2014 21:59:31 Dmitry Torokhov wrote:
> >> > > Hi Pali,
> >> > >=20
> >> > > On Friday, November 14, 2014 08:38:19 PM Pali Roh=C3=A1r=20
wrote:
> >> > > > This patch series fix detection and identifying
> >> > > > trackstick on machines with ALPS devices. Last patch
> >> > > > split trackstick and bare PS/2 mouse packets between
> >> > > > dev2 and dev3 input devices which make sure that
> >> > > > driver will send only trackstick data to trackstick
> >> > > > input device.
> >> > >=20
> >> > > Thank you for splitting the change, unfortunately it is
> >> > > now quite big to apply to 3.18. Any chance you could
> >> > > try implementing what I suggested in
> >> > > http://www.spinics.net/lists/linux-input/msg34029.html
> >> > > and then we can do the more comprehensive solution in
> >> > > 3.19.
> >> > >=20
> >> > > Thanks.
> >> >=20
> >> > Hello, I think that patches 1/7 and 5/7 could do that
> >> > job. I did not tested them alone (without other
> >> > patches), but if you think that two patches are ok for
> >> > 3.18 & stable I can test them...
> >>=20
> >> Dmitry, ping.
> >
> >Dmitry: ping again.
>=20
> Hi Pali,
>=20
> I'm on vacation and unfortunately connection here is
> horrendous so I likely won't be able to do anything until
> after 12/03.
>=20
> Sorry about that.

Hi Dmitry,

I tested that two patches 1/7 and 5/7 on top of 3.18 and it fixed=20
name of ALPS devices. Can you send those two patches to 3.18 =20
queue (just remove comment about speed as without other patches=20
duplicate detection is still called)?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10742929.JHqQP31OPD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR+7QAACgkQi/DJPQPkQ1JdawCcC4z/iwZgkTDl+HBvDE4Cm5Hc
JSAAoIquPaD3rcLtF2YI9KqqS5whIzmQ
=18Vs
-----END PGP SIGNATURE-----

--nextPart10742929.JHqQP31OPD--
