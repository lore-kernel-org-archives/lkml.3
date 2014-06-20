Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265AbaFTWaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:30:00 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47304 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbaFTW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:29:58 -0400
Date: Sat, 21 Jun 2014 00:29:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: add Rockchip SoC PWM support
Message-ID: <20140620222953.GC29400@mithrandir>
References: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
 <1399504115-16257-2-git-send-email-b.galvani@gmail.com>
 <20140617214253.GA24743@mithrandir>
 <20140620220034.GA927@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <20140620220034.GA927@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2014 at 12:00:36AM +0200, Beniamino Galvani wrote:
> On Tue, Jun 17, 2014 at 11:42:58PM +0200, Thierry Reding wrote:
> > On Thu, May 08, 2014 at 01:08:33AM +0200, Beniamino Galvani wrote:
[...]
> > > diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
[...]
> > > +static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_dev=
ice *pwm,
> > > +			       int duty_ns, int period_ns)
> > > +{
> > > +	struct rockchip_pwm_chip *pc =3D to_rockchip_pwm_chip(chip);
> > > +	unsigned long clk_rate, period, duty;
> > > +	u64 div;
> > > +	int ret;
> > > +
> > > +	clk_rate =3D clk_get_rate(pc->clk);
> > > +
> > > +	/*
> > > +	 * Since period and duty cycle registers have a width of 32
> > > +	 * bits, every possible input period can be obtained using the
> > > +	 * default prescaler value for all practical clock rate values.
> > > +	 */
> > > +	div =3D clk_rate;
> > > +	div *=3D period_ns;
> >=20
> > Perhaps shorten this to "div =3D clk_rate * period_ns;"?
>=20
> I will change this, adding a cast to avoid the truncation of the
> result to 32 bits: "div =3D (u64)clk_rate * period_ns;"

Alternatively you could simply make clk_rate a u64 since it's only used
in this context anyway.

Thierry

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpLXhAAoJEN0jrNd/PrOhZQwP/AmbUmZ4KPGzknYJlVMGra0p
DeDeyOwKxZ0pU+zfOEFNRLJJ/Y4eI6mhzCTPPU8O6HR/Qgf+n8PoULXvl9hgOhow
p9eiqEldDzMWM0YxJCBvyosxJ+kpEp2uuYX2jpJoWOIdYS204RrpkY+jMtLcdp9N
5EHx04+23Fqm1MvGvM3/uGVDsvDxYsWK44uvdMJ/gtKfWdLemCivXq5NDZnpJDiv
oGRaJ6uJJcLgWYDcB1ns5VjyeXD6MbE94OIzWQ/g9pYcFO9I8YMeY36xV2JEVxDA
OGY3kjc3MiwG2kHOaU+pmeWYLFb+QueOISLN7g6oEKM48igT78UW2JwF+RTPAC3Z
aSUxfWBu7JTwke6fQ5q+CjDhM+9ZVU99+DXj2TEY/F0oO0Dml2V2IjNGWg7A601+
s+2GJT/HXEM4VWahy79rOC3iUaFkCpaf1FlhdcuQqC9aSdHqvsV2zWbXBx2fo8r5
Xe0ZPDpt6nHiTZRz+ETWNnjGMroTKRmsRDQSORtwCeIW47pA55W8X98X+FJNeAew
C2N8ZnjmHBtF6i2/2faVqpnwAyu+ZdW9tLKdzckLoqItv3s1lHgMb8tdMaw6zFtx
wH7kchqGsfEPV8/B/LFc3PsMO7cioF5/i0RqQ9V3uYkBp/4Pj30Z9YlrY87lfp1c
jvn8wMBv/a+vw3oXgaaR
=D5LL
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
