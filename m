Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaHMJpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:45:45 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57863 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:45:43 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2014 05:45:42 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
Date: Wed, 13 Aug 2014 11:37:28 +0200
Message-ID: <2838655.H5W5zNkR37@merkaba>
User-Agent: KMail/4.15 pre (Linux/3.16.0-tp520-fixcompwrite+; KDE/4.13.3; x86_64; git-411eff3; 2014-08-11)
In-Reply-To: <20140813082756.GB2923@twins.programming.kicks-ass.net>
References: <20140812153812.2923046a@monolith.infinux.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5163038.8xgendr2xQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5163038.8xgendr2xQ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 13. August 2014, 10:27:56 schrieb Peter Zijlstra:
> On Tue, Aug 12, 2014 at 11:07:05PM +0100, M=C3=A5ns Rullg=C3=A5rd wro=
te:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> > > Nice rant, I sympathize with you (just complaining about this on =
G+).
> >=20
> > Made my day.
> >=20
> > > I'm just waiting for Linus to get pissed enough to write his own =
init
> > > routine. Maybe he'll call it "Boot Init Through Computer Hardware=
".
> >=20
> > The trouble is that most of the heavy-weight kernel developers don'=
t
> > seem to care at all about what goes on in userspace.
>=20
> Well, I know for a fact that quite a number do; but so far most peopl=
e
> who care have been able to steer clear of this trainwreck so we did.
>=20
> I'm about to switch all my machines to Gentoo (from Debian) because t=
hat
> will indeed allow you to build a distro without much of this nonsense=

> in -- because as has been eloquently said; you simply don't need this=

> fucking shite to run a 'normal' machine.
>=20
> And the thing is; we're all very busy so we tend to take the 'easy' w=
ay
> out for things like this; but wholesale switching all my machines is
> indeed painful, and I'm not liking.

Just for record:

Debian continues and will (for now and supposedly Jessie lifetime) cont=
inue to=20
work without systemd as PID 1 using systemd-shim and cgmanager.

And no: Debian didn=C2=B4t make the choice easily or without discussion=
. I believe=20
this to be the most controversial decision inside the Debian project an=
d of=20
the Tech CTTE in a decade or so, *after* tons over tons of discussion b=
efore.=20
But one part of the decision is that Debian will continue to support ot=
her=20
init systems at the moment.

Its still being discussed in about all major Debian mailing lists up to=
 now=20
popping up every now and then.

I am not completely opposed to quite some ideas within systemd, but wha=
t=20
really upsets me most in this is the "I know it better than you, go awa=
y!"=20
kind of attitude I also experienced with PulseAudio developers who just=
 give a=20
damn about my use case of wanting to start music playback on one X11 se=
ssion=20
and then switch to another session and *continue* to listen to that mus=
ic.=20
Just as one example where I ran into problems with PulseAudio I can jus=
t get=20
rid of with an easy apt-get purge of it.

And yes, this is where I think wisdom is missing and the ability to acc=
ept=20
constructive criticism is missing. Not all use cases are the same, its =
that=20
simple.

Its the attitude of knowing best for others without willing to accept f=
eedback=20
and discuss things that I am fed up with totally. If it doesn=C2=B4t fi=
t into my own=20
agenda, I don=C2=B4t care, go away. This kind of attitude is not likely=
 to help in=20
the long time. And I think its exactly this attitude that contributes *=
a lot*=20
to the polarity around systemd. If people would get the impression that=
=20
systemd upstream acts *sane* and in a *cooperative* way instead of *for=
cing*=20
things I think there would be lot less resentment about it.

One can have different oppinions about the tone on this mailing list at=
 times,=20
but so far I never found anyone so stubborn not even to let a feedback =
sink in=20
before responding on a regular basis. But I think for systemd developer=
s some=20
kind of feedback ridicules their world view by an amount that they just=
=20
iptable -j DROP it before even receiving it. They may still answer it, =
but=20
also that sometimes to my perception without even having received the f=
eedback=20
first.

That said, systemd in Debian works for me mostly, except some issues wi=
th=20
mounting NFS at the workstation at work. But I will keep sysvinit-core=20=

installed for the time being.

That all said: I believe that any feedback like this is best served on=20=

systemd-devel mailing list =E2=80=93 maybe in an attempt to express it =
in a somewhat=20
polite, yet also direct way. Instead of on LKML, debian-user, debian-de=
vel and=20
you name it what other mailinglists. Cause that would increase the chan=
ce of=20
upstream noticing it.

BTW I am still using KDE / Plasma and last I looked on GNOME (in Debian=
=20
Wheezy) I just thought "Oh my god" and knowing that GNOME also insists =
on=20
PulseAudio, I will continue with a desktop environment that leaves me c=
hoice.=20
KDE developers invented Phonon for a reason. One reason is to be indepe=
ndent=20
of any insanity going on in the lower layers of multimedia handling. Sa=
me=20
thing with Solid. I think meanwhile they rely on systemd-logind, cause=20=

ConsoleKit is unmaintained, but at least they do not depend directly on=
 it. I=20
really hope this will stay this way and they continue to abstract all s=
ystemd=20
use away so that in case systemd will not work out in the long term, th=
ey can=20
adapt easily.

For any account: Depending on a particular init system in a desktop=20
environment is a *bug*. And no way of intelligent arguing around this i=
s=20
likely going to convince me of the opposite.


Also I think:

martin@merkaba:~> ls -l /sbin/init
=2Drwxr-xr-x 1 root root 40648 Aug  3 21:01 /sbin/init
martin@merkaba:~> ls -l /bin/systemd
lrwxrwxrwx 1 root root 20 Aug  6 13:41 /bin/systemd -> /lib/systemd/sys=
temd
martin@merkaba:~> ls -l /lib/systemd/systemd
=2Drwxr-xr-x 1 root root 1084816 Aug  6 13:42 /lib/systemd/systemd

martin@merkaba:~> apt list 2>&1 | egrep "(^systemd/|sysvinit-core)"
systemd/unstable,now 208-7 amd64 [installed]
sysvinit-core/unstable,now 2.88dsf-53.3 amd64 [installed,automatic]

is highly worrying. A one MiB binary as PID 1? Really?

I think I would also have separated cgroup managing from PID 1 also for=
 the=20
price of limited functionality should it not be available. I know there=
 are=20
arguments of systemd developers against it, but one MiB binary for PID =
1 just=20
asks for trouble and bugs.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart5163038.8xgendr2xQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlPrMd0ACgkQmRvqrKWZhMesVgCgqUr4vZS0mEcmbp4c/XkVcMID
0mEAnj5rAWtdXaKD7ST9UKiaSmm4g8Ly
=z8Js
-----END PGP SIGNATURE-----

--nextPart5163038.8xgendr2xQ--

