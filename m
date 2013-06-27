Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3F0RVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:21:49 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56146 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0RVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:21:46 -0400
Date: Thu, 27 Jun 2013 19:21:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627172144.GD4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627060234.GD4824@tarshish>
 <20130627093558.GB8437@lukather>
 <20130627094649.GM4824@tarshish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <20130627094649.GM4824@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Baruch,

On Thu, Jun 27, 2013 at 12:46:49PM +0300, Baruch Siach wrote:
> On Thu, Jun 27, 2013 at 11:35:58AM +0200, Maxime Ripard wrote:
> > On Thu, Jun 27, 2013 at 09:02:34AM +0300, Baruch Siach wrote:
> > > On Wed, Jun 26, 2013 at 11:16:55PM +0200, Maxime Ripard wrote:
> > > > +static u32 sun4i_timer_sched_read(void)
> > >=20
> > > You commit message mentions "64 bits free running counter", but this =
one only=20
> > > returns 32 bit.
> >=20
> > Yeah, the callback setup by setup_sched_clock is supposed to be
> > returning a u32, and clocksource_mmio_init only accepts up to 32 bits as
> > well, so I'm only using the lower 32bits of this 64 bits counter.
> >=20
> > I'll amend the commit log to state this.
>=20
> But using 64 bit counter for sched_clock is much easier that using 32 bit=
 one.=20

Easier in what aspect? Both API looks similar.

> You can either wait for the rest of Stephen's patch set=20
> (http://thread.gmane.org/gmane.linux.ports.arm.msm/4092) before adding 64=
 bit,=20
> or you can just make the trivial change to the now generic sched_clock co=
de.

I'll wait for the Stephen's patches to be merged then, and add support
for 64bits counters to clocksource_mmio_init.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzHSoAAoJEBx+YmzsjxAgKikQAJ6GJfM4AlmnOxwDvb6F5LeS
8/bpnl7VXi2Z27GLrw2r7zVPPLnmZ2NKnB6kddha+Z4ady6lPdvYgsgdNl6HfdIv
OTwV+5U5BJGYyKRF9OG4/4KRR2xtQgrQOml11T3rtgl9IeA9KtqEDQgTjut5geMJ
OeepTm0I2bhM7gwXMX1Bxu//D6krcSLuHUX5R6hoq8rFeuVK59gN7s4/V4dTb8Iu
AD1iJcn4jR+3wnr1UiLUBP/A+RsDlF213AqPd4e+XE9LmskOE4MT3TPsR/PWou1Y
IyiaK2xqH/VpWUUb9/Xy13ymE9hvWNdd3o97Nn4SGBjo8IXnDu5QcfYGQpMazqqj
VQiEaiIvd2XjRfU5QKh9lMfdnYbpub/4We9ZBeP+LQHeULi90/2/Py3RqNEfsYX4
SYGpH4favrK8tDCErhqT3+1H7hrh48yek7VaNhbPDZcdxyIeRvcxEb6DUdC5qEWl
mAYVY50WU6jft33aCCo7ahd7qRALDyfoVDg+WNpUrBt8lpbVP3I80OrYkk56eQcS
G0vjpUE2FCuxD2sr/QK23HKwVTLLB8bfFwZWA0I9veuhh+xxrvZX5Ab4V72U1urj
gL7Tmgd0I4drMXmye67ZHsp4iSvR32s9vk5mSnfvAwefMpr95pFviMmDpcMs2pym
DdBKnUPs8nr1OD3680t4
=8Q0d
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
