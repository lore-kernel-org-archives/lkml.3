Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FYMRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:17:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab3FYMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:17:00 -0400
Message-ID: <1372162617.4006.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] misc/bmp085: Enable building as a module
From: Ben Hutchings <ben@decadent.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 13:16:57 +0100
In-Reply-To: <20130625072728.GB24258@scully.xfiles.lan>
References: <1372083021.21189.19.camel@deadeye.wl.decadent.org.uk>
	 <20130625072728.GB24258@scully.xfiles.lan>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+6IV4yiDuT8YDlE2TbdK"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+6IV4yiDuT8YDlE2TbdK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-25 at 09:27 +0200, Eric Andersson wrote:
> On 15:10 Mon 24 Jun     , Ben Hutchings wrote:
> > Commit 985087dbcb02 'misc: add support for bmp18x chips to the bmp085
> > driver' changed the BMP085 config symbol to a boolean.  I see no
> > reason why the shared code cannot be built as a module, so change it
> > back to tristate.
> >=20
> > Cc: Eric Andersson <eric.andersson@unixphere.com>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/misc/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index c002d86..7a68184 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -451,7 +451,7 @@ config ARM_CHARLCD
> >  	  still useful.
> > =20
> >  config BMP085
> > -	bool
> > +	tristate
> >  	depends on SYSFS
> > =20
> >  config BMP085_I2C
> >=20
>=20
> There is no reason for building the common code stand-alone. The BMP085
> config option is only selectable via the BMP085_I2C/_SPI options.

Yes, but it is then always built-in.

Ben.

> See the select-statement for those options:
>=20
>  config BMP085_I2C
> 	tristate "BMP085 digital pressure sensor on I2C"
> 	select BMP085
>  ...
>=20

--=20
Ben Hutchings
Life is like a sewer:
what you get out of it depends on what you put into it.

--=-+6IV4yiDuT8YDlE2TbdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUcmKOee/yOyVhhEJAQoD1RAAvR3Md8EjTnCRSncYBZqWRbH7Qzharquc
meIDNT3D/RcGk7EOtgP7feWL98bpFSVPEny8JWgruU/zIGtK+iKHn6omrY+pztD/
rwmif4A/b1zdCPvmREJgHlpH/neu7D6uQdelGXqjHpLR028zrJhKeFl+PJID9ljQ
aiaMvHv44Ehc/Cz/rC/4oh4KAHjCe23Dckfaj4spyeSDzdha09v66eGVunt6cu8O
ftxsbvjBNez08cmyfVkOe4KwreHU/budmt2HdA9FHAB50Fq8RA/WvkP9FQPLH6Vn
2npKIc82sU4SujkzSyMgJgy+mk3OvPe/iRd68Q7OqNXeRJBIrbhKQEbTGkWEoB5B
D2OBA25tlTzLQ2uftuMpifEUuVq6lMbVeuDvQgT0EkeUfGTguLdWhaden0pAhucf
75hvgEmgaWtuPwbyl32qCKLAGXdT7xq0TBdb37V2Mru00crkPdIPSraDVBM7YWDC
1uszW66kzDPvWL5prLEm9lxEGl03ljXp2OztJmiKy07FLlyPd2MhuuyqMRjKO7b5
bBU5WIEl+rZvf4IpDjgrufJjhY5m/wwEfwKJIFyXhzX/ex7FDz01tGJRzhcbIh8e
bwiKptLuRKv0bg6cvl3Z0403DixAUj1lwbRIg/Lz15L1IjqF+FWT0NUC/UOcz6K5
DQbskzG8U0M=
=Fx3S
-----END PGP SIGNATURE-----

--=-+6IV4yiDuT8YDlE2TbdK--
