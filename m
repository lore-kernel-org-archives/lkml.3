Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaLRLME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:12:04 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63749 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLRLMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:12:01 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Thu, 18 Dec 2014 12:11:57 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412171854.00902@pali> <CABz95_C1UzbRMgjDKcrdRzr2VGvAwmvWBRrP2116k3CQx+2sRg@mail.gmail.com>
In-Reply-To: <CABz95_C1UzbRMgjDKcrdRzr2VGvAwmvWBRrP2116k3CQx+2sRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2986615.3Jas4HK4QU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412181211.57400@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2986615.3Jas4HK4QU
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 17 December 2014 19:20:21 Steven Honeyman wrote:
> On 17 December 2014 at 17:54, Pali Roh=C3=A1r <pali.rohar@gmail.com>=20
wrote:
> > On Wednesday 10 December 2014 12:51:30 Pali Roh=C3=A1r wrote:
> >> On Tuesday 09 December 2014 21:07:01 Pali Roh=C3=A1r wrote:
> >> > Now we have autodetection code for fan multiplier and
> >> > maximal fan speed so we do not need to have those
> >> > constants for each laptop in kernel driver code.
> >> >=20
> >> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >> > ---
> >> > !!!Please do not apply this patch until all affected
> >> > machines will be tested!!!
> >> >=20
> >> > I tested autodetection code only on Dell Latitude E6440
> >> > (where it worked). Other machines which needs to be
> >> > tested:
> >> >=20
> >> > Dell Latitude D520
> >> > Dell Latitude E6540
> >> > Dell Precision WorkStation 490
> >> > Dell Studio
> >> > Dell XPS M140 (MXC051)
> >> > ---
> >>=20
> >> Can somebody else with dell laptops test this patch series?
> >=20
> > Steven Honeyman, can you test this autodetection patch on
> > your Latitude E6540?
>=20
> Sure. You picked the best possible time of day to ask
> (seriously!) Just applied patches 1,2,3 and so far seems
> exactly as before so it looks OK to me.
>=20

Good, thanks for testing. Now we know that my patches detects=20
correct multiplier for E6440 and E6540 machines which are in dmi=20
list.

> While I was spamming "sensors" I did notice this (output
> trimmed for neatness) but it is unusual my laptop fan is ever
> off so it might have always done this and I would have never
> noticed:
> Each line is about 0.5 - 1 second apart:
>=20
> fan2:        3186 RPM
> fan2:        3231 RPM
> <temp is low enough, fan stops>
> fan2:        10000 RPM
> fan2:        9544 RPM
> fan2:        10000 RPM
> fan2:           0 RPM
> (stays at 0 while fan is off)
> <temp back up, fan starts>
> fan2:        3236 RPM
> fan2:        3597 RPM
>=20
> Ever seen this before? I'd roll back and test again but this
> room and laptop are too warm for the fan to stop completely
> now.
>=20
>=20
> Thanks,
> Steven

On my E6440 I have never seen 10000 RPM.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2986615.3Jas4HK4QU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSStn0ACgkQi/DJPQPkQ1KUxQCgs1xSdvi7CYjBY18Z/kicWwHL
oEQAn3TJFzd4OYCtrbyIky3TXArFe6mZ
=8CHU
-----END PGP SIGNATURE-----

--nextPart2986615.3Jas4HK4QU--
