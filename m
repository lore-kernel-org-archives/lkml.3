Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaK2Qc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:32:58 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34486 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2Qc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:32:57 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 17:32:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411291709.35406@pali> <5479F358.8060506@roeck-us.net>
In-Reply-To: <5479F358.8060506@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5918454.QTO851gV46";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291732.53269@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5918454.QTO851gV46
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 29 November 2014 17:24:56 Guenter Roeck wrote:
> On 11/29/2014 08:09 AM, Pali Roh=C3=A1r wrote:
> > On Saturday 29 November 2014 17:04:07 Pali Roh=C3=A1r wrote:
> >> This patch adds labels for temperature sensors if SMM
> >> function with EAX register 0x11a3 reports it. These
> >> informations was taken from DOS binary NBSVC.MDM.
> >>=20
> >> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >> ---
> >>=20
> >>   drivers/char/i8k.c |  110
> >>=20
> >> +++++++++++++++++++++++++++++++++++++++++----------- 1 file
> >> changed, 88 insertions(+), 22 deletions(-)
> >=20
> > I tested patch on Latitude E6440 and i8k CPU & GPU temps
> > match intel coretemp & amd radeion temps.
> >=20
> > But I would like if somebody with other Dell laptop can test
> > if temperature labels are correct...
>=20
> I have a couple; I'll try to give it a test this weekend.
>=20
> Guenter

Ok, thanks! Can you include also this patch when you will do testing?

https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=
=3Dchar-misc-testing&id=3D723493ca59c8d81fed3e7f261165fee493a29ffa

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5918454.QTO851gV46
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR59TUACgkQi/DJPQPkQ1IiFACfVH17+T/oWFwZM0w0juIJe+qi
wy0AoJbpcc8H2DUSDupm8PV0UsaWJUik
=dos9
-----END PGP SIGNATURE-----

--nextPart5918454.QTO851gV46--
