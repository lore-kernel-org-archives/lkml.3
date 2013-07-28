Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3G1VqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 17:46:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab3G1VqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:46:09 -0400
Message-ID: <1375047960.2546.43.camel@deadeye.wl.decadent.org.uk>
Subject: Re: radeon firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Alex Deucher <alexdeucher@gmail.com>
Date: Sun, 28 Jul 2013 22:46:00 +0100
In-Reply-To: <CADnq5_PYtzY-fnRKbxioUcUTatCS+YvM3Cr-BxF+ZDzZ1uvnCA@mail.gmail.com>
References: <20130721093610.GA30711@pd.tnic>
	 <CADnq5_PYtzY-fnRKbxioUcUTatCS+YvM3Cr-BxF+ZDzZ1uvnCA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1yWuHbzsukCepZC6HcsX"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1yWuHbzsukCepZC6HcsX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-07-21 at 09:12 -0400, Alex Deucher wrote:
> On Sun, Jul 21, 2013 at 5:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Hey Alex,
> >
> > I keep getting people's configs with
> >
> > CONFIG_EXTRA_FIRMWARE=3D"... radeon/RV710_uvd.bin radeon/RV730_smc.bin.=
.."
> >
> > but I can't find those blobs in the k.org fw repo:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.g=
it
> >
> > This here http://www.x.org/wiki/radeonBuildHowTo/ says that
> > http://people.freedesktop.org/~agd5f/radeon_ucode/ contains them, and,
> > AFAICT, the license is the same. So what's the story, are those going
> > into the firmware-linux repo anytime soon?
>=20
> The UVD ucode is already there.  I send Ben the patches for the smc
> ucode week or so ago, but I guess they haven't been applied yet.

I've just pushed them, so they should be available there in a few
minutes.

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-1yWuHbzsukCepZC6HcsX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfWRGee/yOyVhhEJAQouoQ//U1Bw7+UDaAGGqCbjxBMtjNp+4s+nwVam
0aA5qp7Es0IsQmbBcRZe6sYXf4qVpjscsHHBkrRR3MQ6H6xIaRniIXotgzkXw/7n
Yd8lfQbf8sKhidjURj03BuHYMW2MZ6+XnVCYji9aYP9Jzvj93GMRZV0mboRwQgem
qFLcpZn8sl921Aok5Jqs6SBIo+f09+dG8ZYPfSsojdHQ4FgvpHVCzzYK5MjG4Ssj
zHIlyofg1mPyfpt4mW4DZGOdUhh/NapCxKG2kUPU0NNI210a3DpkUZiuooQJ2yXv
dzx6ki4HD4zjYTohXEhze5qac/0jFqUCKFkQzbUvzQwDjFjvIFDa4ipQvcjp/sAy
C6uCySvAgYvxAzEaW9RPv47hhXrz1vYD7uoDR4zF0ngsk755SRQWZWfeUqZ6ODS1
oH5Rp/eMgwFQabLpZh/Csiom6BEjUwKwclH9o4OXKwNL59sr0CkzaZ2qOS8+RO5M
+9p5B4LZTplwYNwSb/9ibIr8VPujTI3ML6FWJG98wlOEif12P+i3YfA0a4NziBPN
DmbJ6NWW6MjdTsh0yPCY3PuwQWyZ/kc1VzCMIP2c0pNd3zUFlh9rUYWaJfwqBqGG
q+efNRGYoV10v4j7DEwKItyEwfL2kUjEw1TZqX6rlojDZPG8C8jAdiv4CQCIbRSi
MfiZMQKukIs=
=9qpS
-----END PGP SIGNATURE-----

--=-1yWuHbzsukCepZC6HcsX--
