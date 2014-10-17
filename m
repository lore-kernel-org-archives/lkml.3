Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJQWXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 18:23:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51579 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaJQWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 18:23:43 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] i8k: Add support for Dell Latitude E6440
Date: Sat, 18 Oct 2014 00:23:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Steven Honeyman <stevenhoneyman@gmail.com>
References: <1412932368-24082-1-git-send-email-pali.rohar@gmail.com> <54384817.6060102@roeck-us.net>
In-Reply-To: <54384817.6060102@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1439247.1sdmdPFO9A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410180023.39473@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1439247.1sdmdPFO9A
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 10 October 2014 22:56:55 Guenter Roeck wrote:
> On 10/10/2014 02:12 AM, Pali Roh=C3=A1r wrote:
> > Dell Latitude E6440 needs same settings as E6540.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Acked-by: Guenter Roeck <linux@roeck-us.net>
>=20

Greg, Arnd: PING

Can you apply also this patch for E6440? Support for E6540 is=20
already in linus tree: 06c88b0d7ad87540405aea7f91d98ef43be04c95

> > ---
> >=20
> >   drivers/char/i8k.c |    8 ++++++++
> >   1 file changed, 8 insertions(+)
> >=20
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index 34174d0..471f985 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -711,6 +711,14 @@ static struct dmi_system_id
> > i8k_dmi_table[] __initdata =3D {
> >=20
> >   		.driver_data =3D (void
> >   		*)&i8k_config_data[DELL_LATITUDE_D520],
> >   =09
> >   	},
> >   	{
> >=20
> > +		.ident =3D "Dell Latitude E6440",
> > +		.matches =3D {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6440"),
> > +		},
> > +		.driver_data =3D (void
> > *)&i8k_config_data[DELL_LATITUDE_E6540], +	},
> > +	{
> >=20
> >   		.ident =3D "Dell Latitude E6540",
> >   		.matches =3D {
> >   	=09
> >   			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1439247.1sdmdPFO9A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRBlusACgkQi/DJPQPkQ1INbACgymeG5Kb0RyMlRZG6j40CBAL3
ecgAn3RWJN730gbXkBDygxQovxh5zBdG
=v/89
-----END PGP SIGNATURE-----

--nextPart1439247.1sdmdPFO9A--
