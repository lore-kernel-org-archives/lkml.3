Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaFJJjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:39:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFJJjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:39:53 -0400
Date: Tue, 10 Jun 2014 11:39:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Henrik Austad <henrik@austad.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610093943.GA6758@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fU5tsrXreH0/dVH0"
Content-Disposition: inline
In-Reply-To: <20140609102027.GA29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fU5tsrXreH0/dVH0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2014 at 11:20:27AM +0100, Morten Rasmussen wrote:
> On Sun, Jun 08, 2014 at 07:03:16AM +0100, Henrik Austad wrote:
> > On Fri, May 23, 2014 at 07:16:29PM +0100, Morten Rasmussen wrote:
> > > The Energy-aware scheduler implementation is guarded by
> > > CONFIG_SCHED_ENERGY.
> > >=20
> > > Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > > ---
> > >  arch/arm/Kconfig |    5 +++++
> > >  1 file changed, 5 insertions(+)
> > >=20
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index ab438cb..bfc3a85 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> >=20
> > Is this going to be duplicate for each architecture enabling this? Why
> > not make a kernel/Kconfig.energy and link to that from those
> > architectures using it?
>=20
> kernel/Kconfig.energy is better I think.

Well, strictly speaking I'd prefer to not have more sched CONFIG knobs.

Do we really need to have this CONFIG guarded?

--fU5tsrXreH0/dVH0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTltJfAAoJEHZH4aRLwOS6Z5kP/iiodeBs2kI+pKiL/FVQkZZP
t3eNRtxiNSbqwEuBD5BcDPGVDug5tWQPOEw4ct+EKtzm5wRuqBG51Lad3PBtL4Hk
GZ3b0ldXWRBtaZp1HE139RYklPhynXvuPcUlA5QjsL1DRa/i01bdEM4h26BifesM
5/JgKzanwT06+5Nmk7LS9K3cw7z20cClgcCg8P1kXD86XibbzjUS80gMKtUdVxEx
MiERFpkn5P2KNlojHYsTsmdykiJpslLoLfiuedT41f1DnTp6VugQzTIj96BU0ZPH
Lkk+qjaILjA/Nc5oliarBzmGwYkKvLgCUOcBlBRejr3A7jraQ4oqVL//gWaueJkW
mogpY0NvLejcmJmwyUD4r6EVPzHhifLAgV4Qsf/YbIRZo0RGkhaHyCXeI4NsInTJ
JArOxCYS7qHdC53Gdd0Fo4xCJI7yYPmKw1E4RjpZIv2/llt5U1ibQXVE8m3xGabJ
YfOKNeeyfUQzWBnuGNEgriZUyw/WgEZG+D/ET8hy3mnystiXkt3fa+Cuagx1U8kV
8p/01yBjJurJWbilhmXSHzVDOk8PRVW0jyML78pW7+uUDpvN2wxiZtis2j3TBo4d
6YkC/+uDtK+wmmDLtbuUyF+AcI1IvYMrcMa9F9jNWYNF2nnbkwTauulclo0uY+Yv
5TXIUSkjBfK3duuykZhi
=0qL6
-----END PGP SIGNATURE-----

--fU5tsrXreH0/dVH0--
