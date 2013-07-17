Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3GQWnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:43:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab3GQWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:43:22 -0400
Date: Thu, 18 Jul 2013 08:42:58 +1000
From: NeilBrown <neilb@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: open conflicts vs. hidden conflicts  (was: [ 00/19]
 3.10.1-stable review)
Message-ID: <20130718084258.37477f76@notabene.brown>
In-Reply-To: <20130717181440.GA16955@gmail.com>
References: <20130715155202.GC29526@xanatos>
	<CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	<20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
	<CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	<20130715195316.GF15531@xanatos>
	<20130717181440.GA16955@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SJNT3FL=+W7TE5JHm9QZJcJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SJNT3FL=+W7TE5JHm9QZJcJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2013 20:14:40 +0200 Ingo Molnar <mingo@kernel.org> wrote:
=20
> 1)
>=20
> Your notion that conflicts and insults somehow hurt group cooperation is=
=20
> wrong. It is a scientific fact that open conflict _helps_ cooperation=20
> while hidden conflict hurts it.

I don't think anyone is seriously suggesting that open conflict is a bad
thing are they?
I don't object to reminding everyone that conflict can be healthy and
valuable, but is seems to miss the main point of this discussion(*).

>=20
> 2)
>=20
> Your notion that insults are harmful because they 'hurt' is misleading to=
=20
> such a level that it's almost wrong.
>=20
> Insults do hurt of course, but that argument misses the full context: in=
=20
> real life the typical substitute for an avoided open conflict is not=20
> singing kumbaya around the camp fire, but _hidden_ conflict.

Open conflict !=3D insults.

Certainly there is an overlap, but it is quite possible to engage in open
conflict without being deliberately insulting.   The appropriate alternate =
to
insults is not "hidden conflict" but rather "civil bluntness".

So you appear to be to be drawing a false distinction here.

(I certainly agree that hidden conflict is bad)

>=20
> 3)
>=20
> I couldn't cite a single example where Linus flamed me unprovoked,=20
> unjustified, just for the sake of letting off steam or any other petty=20
> reason. I've not seen Linus flame newbies and I've not seen him=20
> micro-manage people over unimportant details.
>=20
> In the large majority of colorful flames the flame was over something tha=
t=20
> _matters to the kernel_ - and heck do I prefer a top level maintainer who=
=20
> cares and who is honest, over someone who is indifferent or sloppy ...

If it is something really important (which this stuff is), then surely it is
important enough to make the effort to communicate it effectively.
Being emotional is OK and even getting heated about something you care a lot
about.  But that doesn't justify directing your heat at others.

An extremely good rule of thumb for when you are communicating emotionally =
is
to make "I" statements.

  I don't give a #&*%$ if it fixes a bug - it introduces a @*#$$ regression
  and that @#$*%@ is not acceptable. Ever.

is, in my mind, perfectly acceptable.  Saying

  You've $%^@$% done it again.

is not helpful.

http://en.wikipedia.org/wiki/I-message


(*) One of the amusing things about this whole discussion is that different
people seem that have very different ideas about what the core issue really
is.

NeilBrown


--Sig_/SJNT3FL=+W7TE5JHm9QZJcJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUecd8jnsnt1WYoG5AQLxbg//S3d1oH+VgCIptmUkbefZGC4A/oW1dlXf
Ag/4SVQHw5SlKnK6/EUCo99Bsbusnxr5a4z+jcrThCJRO8r69xWrks42hVDQ/t+d
nSaeZtTbmW8GP9f865QtEAfq1rmO2zQg0HImRQl6ysFx30z/2qQfra4BuVLCSUsj
Jj+EIMiMLcXoYuuTCmvHMvbERmd5yns2926EHSZMRHX9Ob9bwWxWRTmMYQz03hbY
fG2kF3kGwu1ve9LyXWwqsa1HSOEEOgt49AIgjCXAhtGihUYm9qD52E5J4rrgNIEq
7xi0v+4nGCEBJtIKfXp6KUOepmZxU32dSVMDGbRJY8Nst7oJBI+GNqnqMnjb8CZ4
kARgaS+z+A4MfOlMNrCWnWkv4MynCRtvIbSEQ1MEn3ZMOf5ltw7P8bcnoDN2Yrax
nNnHgmSQXsPEDmxx0zxc8FCbn7F9f90RX1MvW5xh09qbMRmngD/jD57aurbTzcoy
uLFQQfXlo8dj6hbteM4sgHP7lJX63/Yilc6BHIfOr0XawkQaXLgkifi6mu5vniLF
3WSedl5t/JGSykRosUc6REXbvqAMtVR7XhEFhfVZdnRGZ4JoPz+/MNy11vJea2DB
MYOgn2i9zzU7oPUaGwkWS2Fv0lUOTKKl0OjOqUWa2iU7KUV+NufgpU+JS2NVyTvh
NZicCMmup4o=
=aeCf
-----END PGP SIGNATURE-----

--Sig_/SJNT3FL=+W7TE5JHm9QZJcJ--
