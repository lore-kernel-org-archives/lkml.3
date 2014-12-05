Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaLEBxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:53:40 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43198 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaLEBxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:53:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Fri, 5 Dec 2014 02:53:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <4874352.BarQGyiSH1@xps13> <20141203115135.GA42394@vmdeb7>
In-Reply-To: <20141203115135.GA42394@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14772405.fP2IpgDxjI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412050253.35324@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14772405.fP2IpgDxjI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 03 December 2014 12:51:37 Darren Hart wrote:
> On Thu, Dec 04, 2014 at 09:50:02AM +0100, Gabriele Mazzotta=20
wrote:
> > On Wednesday 03 December 2014 00:43:21 Darren Hart wrote:
> > > > +     int kbd_timeouts[];
> > > >=20
> > > >  };
> > > > =20
> > > >  static struct quirk_entry *quirks;
> > > >=20
> > > > @@ -76,6 +89,10 @@ static int __init dmi_matched(const
> > > > struct dmi_system_id *dmi)>
> > > >=20
> > > >       return 1;
> > > > =20
> > > >  }
> > > >=20
> > > > +static struct quirk_entry quirk_dell_xps13_9333 =3D {
> > > > +     .kbd_timeouts =3D { 0, 5, 15, 60, 5*60, 15*60, -1 },
> > >=20
> > > Where did these values come from? Were they documented in
> > > the libsmbios project? Can you provide a URL to that?
> > > These really should be described by the firmware, but if
> > > they aren't, nothing we can do about it.
> >=20
> > I took those values from a Windows utility provided by Dell.
> > I tried to find a reason for that specific list to exist,
> > but I couldn't. The reason why it's there is that the BIOS
> > of my laptop accepts any timeout, but it silently sets the
> > timeout to 0 (i.e. illumination never off) if a value not
> > in that list is given. So, given the wide range of of
> > possible input values, we added that quirk. This is
> > something my laptop does, Pali's behaves differently and
> > such a list is not needed.
>=20
> Let's get a comment above the quirk describing the scenario.

Ok, I will add comment above quirk.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart14772405.fP2IpgDxjI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSBEB8ACgkQi/DJPQPkQ1JkfwCggygbi7y96IMnC3uPlXCv4IIz
d3AAniNVVwv5w4V5489D5SXMera30F+L
=HhRv
-----END PGP SIGNATURE-----

--nextPart14772405.fP2IpgDxjI--
