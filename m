Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3GQC6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:58:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43903 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab3GQC6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:58:21 -0400
Message-ID: <1374029882.2537.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Jul 2013 03:58:02 +0100
In-Reply-To: <20130716201041.GC20721@1wt.eu>
References: <20130712005023.GB31005@thunk.org>
	 <20130712051451.GC25815@1wt.eu>
	 <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
	 <s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk>
	 <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
	 <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
	 <1374000084.6458.36.camel@gandalf.local.home>
	 <20130716191147.GA1680@kroah.com>
	 <1374003789.6458.55.camel@gandalf.local.home>
	 <20130716201041.GC20721@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8sIWsnkmxR8DCU1q+CBr"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8sIWsnkmxR8DCU1q+CBr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 22:10 +0200, Willy Tarreau wrote:
> On Tue, Jul 16, 2013 at 03:43:09PM -0400, Steven Rostedt wrote:
> > On Tue, 2013-07-16 at 12:11 -0700, Greg Kroah-Hartman wrote:
> >=20
> > > People mark stable patches that way already today with a:
> > > 	Cc: stable <stable@vger.kernel.org> # delay for 3.12-rc4
> > > or some such wording.  I take those and don't apply them until the no=
ted
> > > release happens, so you can do this if needed.
> >=20
> > I guess the thing is, are stable patches prone to regressions. Do we
> > just do that for patches that we think are too complex and may cause
> > some harm. Of course, there's the question about having a clue about
> > what patches might cause harm or not.
>=20
> We'd probably better switch the tag to be "# now" to imply that we don't
> want to delay them, and that by default those merged prior to rc4 are all
> postponed.

I think this might work.  I definitely agree that most fixes aren't
worth the risk of allowing into a stable release that quickly, so it's
the right default.

> I suspect that the switching could be mostly automated this way,
> avoiding to add burden to Greg :
>=20
>   - if commit ID >=3D -rc4
>     move to immediate queue, it's a "critical" fix as per Linus' rules
>=20
>   - if Cc: stable line has "now" at the end, move to immediate queue as
>     the maintainer takes this reponsibility ;
>=20
>   - otherwise move to the next .2 queue.

I can't speak for Greg, but that seems reasonably easy to implement.
(Which I would have to do, as I was unable to reuse Greg's scripts.)

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-8sIWsnkmxR8DCU1q+CBr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeYIOue/yOyVhhEJAQqTJQ//UoR0fe5UnGpiQSc5mrzJ9uU1558rS3y7
/ZSdEsbiYJS70GIQLgoZNkslCsU5WBIE72XTHNb6dWu/Y2/KpLiuoxAn3iaCJwZN
hUpMs0y9X5oano2mItbh4HHHq+3wBpwdCXmQ91OB8hA7U4r7hiB0JTFub5/jLFZC
z+xH5Ce5jHIrNvmsWeU0KhCZzCEAnYVMzS5poAJbueg9xRxZtF37zXGPP5SrZROK
noBCGUJv+/LFgyO3zCRL86YUwnICM61C40HykEV6CjJFxl748D9dBwb+Oqr1Tt49
GEY+EPE3RRb7/JU836YsYE6PnhU3mdT3eKMAEWN+UVe1XvmOKH1eUgXmSWxcRRzy
0R5FTzSu9YGA9uIPY6JO7c7LAfg6b4ETcxg1WgNL68QOPofoxiAP8btsg/qPbgEf
GfyrG/+XYgkwVYzSPFAtUodJz6CoxTeBIwZm8LgqUe8ePGq99SD3YB+UJOOCJE2/
kQoiSODJZYqvlWmJLdHWc/BJRzruF6LxeTqQ4i9YEQczMPtbi+clHYBCtngqmOS2
6KKbHlgntbrm1rwfJ+7bYpm2smyfqttN0E2plMIx6gzVqM29tP1trwbtgqnwfSxn
I20z1qCYz/syfnjF36Rx+PUpHnMfx80TQQm4BxiTk1dJsl08SwRFSKp80u+nwdFW
C+w+WlmUK9E=
=mnA1
-----END PGP SIGNATURE-----

--=-8sIWsnkmxR8DCU1q+CBr--
