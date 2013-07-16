Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab3GPEKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:10:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39768 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab3GPEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:10:11 -0400
Message-ID: <1373947801.31067.157.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 05:10:01 +0100
In-Reply-To: <CAPM=9twPxz60WObwG5SuCxFrGTr7KzQyS3iqGnF8MQJPUZuHOg@mail.gmail.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <1373925699.17876.218.camel@gandalf.local.home>
	 <20130716000623.GB26261@kroah.com>
	 <1373940594.17876.241.camel@gandalf.local.home>
	 <1373942486.31067.122.camel@deadeye.wl.decadent.org.uk>
	 <CAPM=9twPxz60WObwG5SuCxFrGTr7KzQyS3iqGnF8MQJPUZuHOg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Hz7Yp6NbV3Znxpf9Uk66"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hz7Yp6NbV3Znxpf9Uk66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 13:27 +1000, Dave Airlie wrote:
> On Tue, Jul 16, 2013 at 12:41 PM, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > On Mon, 2013-07-15 at 22:09 -0400, Steven Rostedt wrote:
> > [...]
> >> > > How important is the stable releases? Are maintainers willing to d=
o a
> >> > > little more work now to make sure their subsystems work fine in ol=
der
> >> > > kernels? This isn't the same stable as it was 8 years ago.
> >> >
> >> > And that annoys the hell out of some Linux companies who feel that t=
he
> >> > stable kernels compete with them.  So people working for those compa=
nies
> >> > might not get as much help with doing any additional work for stable
> >> > kernel releases (this is not just idle gossip, I've heard it directl=
y
> >> > from management's mouths.)
> >>
> >> Hmm, this is new to me. Really, I thought the whole point of the stabl=
e
> >> releases was to help Linux companies.
> > [...]
> >
> > I also heard some managers decided their kernel source packages should
> > have all the patches squashed together to make them harder to cherry-
> > pick... could it have been the same company?
>=20
> Greg loves to tell stories about RH management, but really if he can
> find any engineer who works for RH that says he can't work on stable
> due to being told by management, I'd be surprised.

To be clear, I very much appreciate the level of contribution to stable
from RH developers.  And it's a little too high to believe these are
just a few rogues flouting policy. :-)

> Maybe when stable
> first surfaced there was a hope of it being close to RHEL,

The lack of non-trivial driver backports means it's not really
competitive with any commercial distribution.  (But it looks a little
better if you add in compat-drivers.)

> but at this
> point stable has little to no usefulness from a RHEL point of view,
> and since nearly all the RH employed maintainers all do stable work, I
> can't see why Greg would think this matters.
>=20
> In fact Greg how much of stable queue does come from Red Hatters?

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-Hz7Yp6NbV3Znxpf9Uk66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeTHmee/yOyVhhEJAQrx8g//R3mDB74oiS8W3Ej5G1oCNaZo+T8im+HT
XViDXG1N/69KnZG//Ku5fuKDizdyvdHY1eQ7/wRn7aFYQl5Gu8/A/41/i9A+kPtI
LhAr4Bq/08q1zcOKHJw0Lw206Waf+utrXY5MsIrc8A4Ul4E6FZ+QvcWtypH3ZhLr
PRoKqLV8vpJewVUWx/fV2wXDjBPKjeRSJEuFm+QKKnxCFOiGlzB0iJDriN6pO7zj
MnBBj1RNBM+aDozS7xRGzxVEo9MPbzQcT2S8YuzfuxxIB3vXcM73QXe05UyCH+Fb
oPBfjmqTBo7jl4oxESK0H8lrSbW0Mj36qRGqJ27sJSH16sgchzmAV+0UgYVSLbq3
YbvNiDpfnKk3TK6+b9Gl7jsnWFReFO5st7Xn/9qK8qskaeL3MzFOeTHc4MjTtoNV
Ito6X1Us7k+nLBm2R7p83OE1S5YPGY38uL0fuC7KOdu6HOubx9qCK5/Iyo3G+2eX
Ag0eIiYzNn510qKjlxhRsTQF4Bv/MzTHQ9+XLMyvygwisdNXHqmfFHaz6D1m3yk0
e1i6QdrDvM8ZMajpDKPIxiFOkkf0j5k4K2Asqgs5TWKzh/MrvuMIRM/X7FQTTXZm
C/c/NNFhSDYycMPVI2W3uJTF/q5gGck4wfdjdAvJOtvcq3fpOOsh9dZSWm7XdYbs
O9dRBgglUuc=
=YlBT
-----END PGP SIGNATURE-----

--=-Hz7Yp6NbV3Znxpf9Uk66--
