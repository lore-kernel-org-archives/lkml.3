Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3GQDyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:54:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44075 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab3GQDyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:54:15 -0400
Message-ID: <1374033238.2537.98.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 17 Jul 2013 04:53:58 +0100
In-Reply-To: <20130716163615.GB17231@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <1373941801.31067.113.camel@deadeye.wl.decadent.org.uk>
	 <20130716061324.GA19052@kroah.com>
	 <alpine.LNX.2.00.1307161109480.29788@pobox.suse.cz>
	 <20130716163615.GB17231@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Sy/YrTEst2sQGuElJMrm"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Sy/YrTEst2sQGuElJMrm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 09:36 -0700, Greg KH wrote:
> On Tue, Jul 16, 2013 at 11:11:24AM +0200, Jiri Kosina wrote:
> > On Mon, 15 Jul 2013, Greg KH wrote:
> >=20
> > > > Anything that's being reviewed on the stable list is public.  I kno=
w
> > > > this is an old argument, but if you point out a fix you *know* has =
a
> > > > security impact then you'll help general distribution maintainers a=
nd
> > > > users a lot more than you help the black-hats who are quite capable=
 of
> > > > recognising such a fix (if they haven't already spotted and exploit=
ed
> > > > the bug).
> > >=20
> > > I'm sorry, but you know I will not do that, so asking about it isn't
> > > going to change this behavior.
> >=20
> > I just followed up in the other thread, where Ted was explaining why th=
e=20
> > huge /dev/random rework was a -stable material.
> >=20
> > Why specifically would it be wrong to be open about this being security=
=20
> > related, and providing the necessary data (i.e. at least reference to=
=20
> > http://factorable.net/) publically?
> >=20
> > I fail to see what the point behind hiding this would be.
>=20
> I'm not "hiding" anything, all I'm doing is using the exact same
> changelog comments that are in Linus's tree, and nothing else.

Right, and I wouldn't expect you to edit commit messages.  But if a fix
was privately proposed to you for stable on the grounds that the bug is
found to be exploitable, maybe you could include that information in the
cover message for the review.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-Sy/YrTEst2sQGuElJMrm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeYVVue/yOyVhhEJAQpP+A/+PGW/FIO9Sp2ocvBFI99oNyRmc8c1uRsK
jUFZdiNO7wUVIdJNvy/7cO4U6xjQmTq5pQOJHNSzKsbWavx+GyT4xm7TegdAAJLR
MIcQNX6enNErc2hfyNM6FJiynLJWU7zaPHk/L4mauxkla9SjbYL5FP/0xQz2jWYB
Uoj7wd9enrG5JHBA48n/WOLMiuI4Zr6nHhJmg5h8IbMv1Jlh/H1QO9znyHAYoMep
mFEECokYqT6JLkaI2pHdFVHoPezjg4lMzdA//opCvhSJhzxKGamdfUTDnliIYvIi
J5qUeNWXTAc6in6+jTaEz0MLjtMBDI394CWzXU5rqy5AZ3I7sp3KEGMwpD2d1x7r
bsYlJegA/yDDlZ5SqC0Kk0xeuHiu8j/IepU4PsNB9a1yQifMPBT6b84d92B72Kyi
+SBf6bvS4XmTyoSH8vmA6jSkYD93bparO/8XsKLxJWwzjeyCwsEQIyJws2jGiEKA
NU/+IZYjnHQ8sQSZ9FbD6JmP+XQ7BJ0DeaWauI89IxjAeHifAStpuSK7/Fy94SSC
n2bSr3N6SWPM4FDwL/aoLO7qCBmXoKr1JwWYzdb0EcMwGyzZKFTZut2JPdzLdkyx
3oxe7YmzJym/3Vko6vny7ylCUpyAW3tRXbge9upeUJ/lipzjsdFOlPc3wFrl9CLg
WGSFebnlv0E=
=3Ui2
-----END PGP SIGNATURE-----

--=-Sy/YrTEst2sQGuElJMrm--
