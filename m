Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3HNJC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:02:57 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33273 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471Ab3HNJCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:02:54 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
Date: Wed, 14 Aug 2013 11:02:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
References: <1836330.fGgIDqPTNA@pali> <3b367f03-0ab0-4b22-893e-3f03f16a496e@gmail.com> <520A3AD0.5000304@labri.fr>
In-Reply-To: <520A3AD0.5000304@labri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3626654.7R56kGWjBR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308141102.47960@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3626654.7R56kGWjBR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 13 August 2013 15:55:28 Martin Peres wrote:
> On 13/08/2013 09:53, Pali Roh=C3=A1r wrote:
> > On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres=20
wrote:
> >> On 13/08/2013 09:23, Pali Roh=C3=A1r wrote:
> >>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
> >>  ...
> >>=20
> >> You can check the temperature by running nvidia-settings.
> >> If you can't see the temperature in it, then nvidia
> >> doesn't support it on your card and
> >> I'm not sure we should :s
> >>=20
> >> Thanks for the vbios you sent me in private. For the
> >> others, the reason why he doesn't have temperature anymore
> >> is because his vbios lacks sensor calibration values.
> >=20
> > In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" -->
> > "Thermal Settings" is:
> >=20
> > Thermal Sensor Information:
> > ID: 0
> > Target: GPU
> > Provider: GPU Internal
> > Temperature: 70 C (now)
> >=20
> > I looked in Windows program SpeedFan. It found Nvidia PCI
> > card and reported "GPU Temp" about 68-70 C. So it looks
> > like both nvidia driver and windows SpeedFan program
> > reading same values.
>=20
> Great, I'll cook you a patch in a bit and you'll see what the
> temperature is like. It won't be perfectly accurate but there
> is some kind of default for nvidia cards of this generation.

Ok, send me patch and I can try it if it will work and report=20
similar values as windows or nvidia driver.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3626654.7R56kGWjBR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlILR7cACgkQi/DJPQPkQ1IrAQCghgvNWKDLBvZ9gKc+pc/9S9kl
tLsAn025gvL5QE70IOOuM5rEE56m8pqt
=z1I+
-----END PGP SIGNATURE-----

--nextPart3626654.7R56kGWjBR--
