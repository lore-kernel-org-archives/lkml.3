Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab3GPWNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:13:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329Ab3GPWN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:13:29 -0400
Date: Wed, 17 Jul 2013 08:13:12 +1000
From: NeilBrown <neilb@suse.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML (was: [
 00/19] 3.10.1-stable review)
Message-ID: <20130717081312.0227d85a@notabene.brown>
In-Reply-To: <1373999229.2148.87.camel@dabdike>
References: <20130715155202.GC29526@xanatos>
	<CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	<20130715174659.GC15531@xanatos>
	<CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	<20130715180403.GD15531@xanatos>
	<CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	<20130715184642.GE15531@xanatos>
	<CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com>
	<20130715195316.GF15531@xanatos>
	<20130715204135.GH15531@xanatos>
	<CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com>
	<1373926109.17876.221.camel@gandalf.local.home>
	<CA+55aFwdYxfgE8B4oPVFXWTJUcnDKnM4cchZ=t08mFwEHX+TAA@mail.gmail.com>
	<1373999229.2148.87.camel@dabdike>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H7AC/5b5cL17HhKhYCfqpdi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H7AC/5b5cL17HhKhYCfqpdi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Jul 2013 22:27:09 +0400 James Bottomley
<James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2013-07-15 at 15:38 -0700, Linus Torvalds wrote:
> > On Mon, Jul 15, 2013 at 3:08 PM, Steven Rostedt <rostedt@goodmis.org> w=
rote:
> > >
> > > Can we please make this into a Kernel Summit discussion. I highly dou=
bt
> > > we would solve anything, but it certainly would be a fun segment to
> > > watch :-)
> >=20
> > I think we should, because I think it's the kind of thing we really
> > need at the KS - talking about "process".
>=20
> Can you formulate the process issue to discuss?  I've heard "Linus needs
> to yell less at people" and "the mailing lists need to be more
> 'professional'" neither of which seems to identify an actual process.
> Are we perhaps discussing guidelines for giving feedback on patches?
>=20
> > At the same time, I really don't know what the format would possibly
> > be like for it to really work as a reasonable discussion. And I think
> > that is important, because this kind of subject is *not* likely
> > possible in the traditional "people sit around tables and maybe
> > somebody has a few slides" format.
>=20
> > A small panel discussion with a few people (fiveish?) that have very
> > different viewpoints, along with baskets of rotten fruit set out on
> > the tables? That could be fun. And I'm serious, although we might want
> > to limit the size of the fruit to smaller berries ;)
>=20
> How about Lychees?  They're prickly on the outside, very wet on the
> inside and have large stones ...
>=20
> But what are the viewpoints?  "maintainers need to yell more"?
> "maintainers need to yell less"?  I don't think I agree with either.
> I'm perfectly happy to run linux-scsi along reasonable standards of
> civility and try to keep the debates technical, but that's far easier to
> do on a low traffic list; obviously, I realise that style of argument
> doesn't suit everyone, so it's not a standard of behaviour I'd like to
> see universally imposed.  In fact, I've got to say that I wouldn't like
> to see *any* behaviour standard imposed ... they're all basically cover
> for power plays (or soon get abused as power plays); the only real way
> to display leadership on behaviour standards is by example not by fiat.

I agree that we don't want a formal "standard of behaviour" - it would be j=
ust
as bad as the standard for white space.
I also agree that "by example" is the best way to affect behaviour standard=
s.
However this effect can be positive or negative (or both).
And different people have widely varying opportunities to demonstrate
behaviour.

So I don't think this is about saying "maintainer need to do X".
It is about a non-trivial (I believe) section of the community saying "We a=
re
bothered by the current de facto behavioural standard"  i.e. it is feed back
to those in a position to set standards, that their behaviour is having a
negative effect beyond their apparent intention.

Or if you want a sound-bite:

   With great power comes great responsibility.  Are we being responsible?

The particular issue that I see is the venting of negative emotion.  Email =
is
a particularly bad medium for communicating emotion.  People will *not* hear
what you are trying to say if it is couched in strongly emotional terms.
It isn't the particular word choice or whether the emotion is directed at a
person, or a piece of code, or a cat photo.  The presence of negative emoti=
on
in an email will drown out everything else (for some readers at least, many
I believe, certainly not all).
So my personal perspective on what it means to be responsible is:

   Don't flame:  include the facts, exclude the emotion.

I have no desire to impose this on others, but I'm happy when people impose=
 it
(or something like it) on themselves.

NeilBrown

>=20
> James
>=20
>=20
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss


--Sig_/H7AC/5b5cL17HhKhYCfqpdi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeXFeDnsnt1WYoG5AQKEqA/8D+jNUHlhoUbSfJy+gcf9nsF7/VHtbEoc
t7Wlwm09mVmo+H+URf3mEmNyuKMpfg+/jRrGJtMg73VMKnemP0lGFUkNpSoRpwXm
bdkAxm/h9AaFfncbsByEkkQkGFKpfj9SLEQP2x/XncPKbnJRuwys7ZGrCwnuZ9h9
dnONFEklmSi6FQjlH9J0y15G4xR0jjfYTg2AQ0UG8TDUOjZiL1tt7yv4ZwYWA8mM
TSMVgsnJoE19MjTNys4IT9hL63YPrqEbOC9K575Pu+plHq6+pJ5Axd3tq7KUJeLV
mr1xVRrnAAnnWCgNiTp0hzUjdPeSHD5tTNc0j1vag6SysA5/b6oJdHALBQga/ssg
uu/8p/xX1ds4303eO0FDFCiiD9oQEVVgxoEG5t6xI70I3B/TBgfS+VQ/WonIMbia
j9F2oQDUoc4rQWvvcBYOsbHs5tTr3PpWQ68H2BliEP5jjtVUV0d0/lOPvRdfcwpQ
LkHPBXXqlEczCVaTdRPCwL8nWbtqxxHmKlvfpJwpFwJ6vNQHbt9ero6OVcqHiwqz
+hc051P8pniaCjlWYPG1H1QtbzCmvR/EHMNDMCljy1/q15ENmd2hoKbc1eVGPsAd
w4O/2Ti12nQSROUrrQCZRan+OCiRcy0ersGm8uyND0f3fp6stpdhYhjhLVaJpua/
nOYiiZNVpu0=
=FCMp
-----END PGP SIGNATURE-----

--Sig_/H7AC/5b5cL17HhKhYCfqpdi--
