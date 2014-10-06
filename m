Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaJFOsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:48:40 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62402 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaJFOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:48:38 -0400
Date: Mon, 6 Oct 2014 16:48:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141006144835.GB1744@ulmo>
References: <1410983638-24915-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410983638-24915-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20141006132404.GC26921@ulmo>
 <20141006143008.GC15599@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20141006143008.GC15599@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 04:30:08PM +0200, Alexandre Belloni wrote:
> On 06/10/2014 at 15:24:05 +0200, Thierry Reding wrote :
> > On Wed, Sep 17, 2014 at 09:53:57PM +0200, Alexandre Belloni wrote:
> > [...]
> > > diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
> > > new file mode 100644
> > > index 000000000000..643f84ea013e
> > > --- /dev/null
> > > +++ b/drivers/pwm/pwm-sunxi.c
> > > @@ -0,0 +1,371 @@
> > > +/*
> > > + * Driver for Allwinner Pulse Width Modulation Controller
> > > + *
> > > + * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-elec=
trons.com>
> >=20
> > This is somewhat weird. So you are the copyright holder, not your
> > employer? The email address is somewhat misleading.
> >=20
>=20
> It has been done on my free, unpaid time so yes...
>=20
> Anyway, even my employer could not actually claim to hold copyright on
> what I'm writing as this right is not transferable in France.

Interesting. And yet there's a bunch of Copyright.*Free Electrons in the
kernel. There's also this little mention on Wikipedia:

	"The droit d=E2=80=99auteur or authors' rights, in France, Belgium or
	Germany, grant (subject to some exceptions) the benefice of the
	right to natural persons (the author or his heir(s)) and denies
	it to legal persons (except for collective works, and for
	software), ..."[0]

Which indicates that for software this isn't true. Anyway, what I meant
to say was that it's unusual (at least in my experience) to submit code
authored and copyrighted using a corporate email address. So typically
I've seen people that work on open source in their spare time use a
different email address to separate these "identities".

But I don't mind this all that much, it just jumped out at me.

[0]: http://en.wikipedia.org/wiki/Copyright_law_of_France#Difference_betwee=
n_copyright_and_droit_d.27auteur

> > > +static const u32 prescaler_table[] =3D {
> > > +	120,
> > > +	180,
> > > +	240,
> > > +	360,
> > > +	480,
> > > +	0,
> > > +	0,
> > > +	0,
> > > +	12000,
> > > +	24000,
> > > +	36000,
> > > +	48000,
> > > +	72000,
> > > +	0,
> > > +	0,
> > > +	0, /* Actually 1 but tested separately */
> > > +};
> >=20
> > Did I already mention that this was really weird?
> >=20
>=20
> I'm not sure what you want to do here then. This is simply coming from
> the datasheet. The last one (0xF) being a bypass is actually only existin=
g on=20

No need to do anything about it. I just think it's really, really weird.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMqvCAAoJEN0jrNd/PrOhYogP/2xCswAFUMvT562f8TOMDkr8
DDmVTBAW1RPvzL5AguB6MZxmfrOrw7Zv1JqPQd+oG0H3GanwZLEWMp19ry7n7WoA
KoLnOPaB9ckVVeGccVOab96PDji3WPhs/0Ju3TvCznP0bgqw5nngC4aEoOawXN9r
SkAhauEBGsv2Yemc2t/20NRCORvLbFBjVCYgRFDhMK5MMpXnT1O3UtLV7FQ3sAJC
rznD6pwXIZudvVm/X1UKLj6w4oQuxQPRUqIABO9Xs/YxbHj3+66UNOgGZs83zhvu
oUYSpRAeCmimK0BzqX+vY156nPIBfTVFRNO4thMPpk2tMaqFVj+xQGPs0tJeO5Lq
wU2itkX0VlafjLiqVqS/cHG/Z9Q02ykGnzux0t3fDesSwvuy4gA0DJp0nuPR95UQ
ILj2NmrsiT1WBQ1u3zA9FwPDpADaWP8WNegOESBNp4IaY5t3ukPUDlUsJ52BK/Ee
C3eIb0tnRP85lU5c0XvxaQ/RcLWhXFnHTsdb5lGxQMDmF7Ry9ohsfLAe+XWaV01H
FyfWzAtQVOkwVRsMJSfdhHCA7aZGCfkr65oVRdeJ953vZhsALpdT4TX78O1QX/Fa
B7hlXHUsacDMrJQkhO7oGioQWMG4nMkzuYH/EfOY8CXcElRL1W4C2a6QSg7OkSPS
rf1QdIfWUzS8Dv9oS8vZ
=rpnl
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
