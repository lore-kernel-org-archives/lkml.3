Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3F0TQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:16:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56622 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0TQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:16:50 -0400
Date: Thu, 27 Jun 2013 21:16:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627191647.GE4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627060234.GD4824@tarshish>
 <20130627093558.GB8437@lukather>
 <20130627094649.GM4824@tarshish>
 <20130627172144.GD4319@lukather>
 <20130627173643.GQ4824@tarshish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <20130627173643.GQ4824@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 08:36:43PM +0300, Baruch Siach wrote:
> Hi Maxime,
>=20
> On Thu, Jun 27, 2013 at 07:21:44PM +0200, Maxime Ripard wrote:
> > On Thu, Jun 27, 2013 at 12:46:49PM +0300, Baruch Siach wrote:
> > > On Thu, Jun 27, 2013 at 11:35:58AM +0200, Maxime Ripard wrote:
> > > > On Thu, Jun 27, 2013 at 09:02:34AM +0300, Baruch Siach wrote:
> > > > > On Wed, Jun 26, 2013 at 11:16:55PM +0200, Maxime Ripard wrote:
> > > > > > +static u32 sun4i_timer_sched_read(void)
> > > > >=20
> > > > > You commit message mentions "64 bits free running counter", but t=
his one only=20
> > > > > returns 32 bit.
> > > >=20
> > > > Yeah, the callback setup by setup_sched_clock is supposed to be
> > > > returning a u32, and clocksource_mmio_init only accepts up to 32 bi=
ts as
> > > > well, so I'm only using the lower 32bits of this 64 bits counter.
> > > >=20
> > > > I'll amend the commit log to state this.
> > >=20
> > > But using 64 bit counter for sched_clock is much easier that using 32=
 bit one.=20
> >=20
> > Easier in what aspect? Both API looks similar.
>=20
> You can just implement your own simple sched_clock() that just returns th=
e=20
> current value of this 64 bit counter, and do away with all the tricky cod=
e in=20
> kernel/time/sched_clock.c (in tip.git) that is needed to make the 32 -> 6=
4=20
> extension safe. This is not compatible with multi-platform kernel, though.

Which is a deal-breaker for us.

I'll use the setup_sched_clock_64 introduced by Stephen then :)

Thanks for the time you took to review these patches!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzI+fAAoJEBx+YmzsjxAgsc4QAIVIFry/X42maC7Wb9gfZ31d
KodztwtV5dxGJWTzcYXr5WgWC3WVKFcP0rs+YzQQm4ElGM0x5BjNkWzyPk0VK3Zb
FkXrEiwKy6FRPH65Ru9KJ7mIpsmGZP6rvzVY1PkmM3gHlCg4Gl7F38WrqpvLI2wS
aYGmUzGjaOu9hvStgLDX0But90SU/SWXBXQLUXYbzfXfDhO6KUWHWegcPZqoCFhk
JKwaM1wG/AoiwZjONXF6E41EKlJXEEvF4uk1f9raX5A05erqyly1wprefeiFpSdm
Nl2gdGmKYZMIjN8p5RC1djwikkPgRANHpGr7M1Srvu+Xx8b2C0TIXxhMpGLPtBwn
8QKgWGA8iqImy3pn/eaZ8U3yZCuCDbmR7wJ/EAyibWm+7C0fzQ3aKzYLJo8yNkk7
KcWoPn+jbOmFKTyLV4Q+jjhzMiNrAW0Yhf5d04y7JStm6YxRRGTefyxNdgtaeoO5
5jK0lrwS3bzwCLbHvcb9f5e4+i460KwDYwqLLLtxTx8vVIuDMZ3YzX68l7iicKtC
yvKnHLRwxL20puKKaWhETfLYTUNLxT196iwnR/U0HPlnMaBKXN4NToK4tYpu4mye
nA5m1E/19LX6eul9OtRtYgDiou/qCJeYwgSSGvigcfdrBH8UYL4Q1AdQnEN1yXDR
RrnaWYrOcs7x3AouZfz1
=Cdpq
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
