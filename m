Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaHANzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:55:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43644 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbaHANzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:55:10 -0400
Date: Fri, 1 Aug 2014 08:54:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tero Kristo <t-kristo@ti.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>, dt list <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <jason@lakedaemon.net>, Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, <tglx@linutronix.de>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 29/35] arm: omap: intc: switch over to linear irq domain
Message-ID: <20140801135407.GB9216@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140729154057.GE17808@saruman.home>
 <20140729163345.GF17808@saruman.home>
 <20140730060420.GY29045@atomide.com>
 <20140730144059.GA7272@saruman.home>
 <CAGo_u6ou+MoKOE_tTTmjxyFNW=jTaN9vnTsHrxR6sQHsieJyLA@mail.gmail.com>
 <20140730162038.GH7272@saruman.home>
 <20140731062843.GA29045@atomide.com>
 <53D9F6D5.1080307@ti.com>
 <20140731134945.GB19512@saruman.home>
 <53DB877A.5000004@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <53DB877A.5000004@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 01, 2014 at 03:26:34PM +0300, Tero Kristo wrote:
> >>>>>>I might have sent the wrong version as I had that same build error =
and
> >>>>>>fixed it localy.
> >>>>>>
> >>>>>>>it fixes the regression for me, Also now the whole series works for
> >>>>>>>me :)
> >>>>>>
> >>>>>>good to know.
> >>>>>>
> >>>>>>What do you want to do now ? Wait for PRCM to become a driver ? Wai=
t for
> >>>>>>Nishanth's series to get accepted ? I guess the same thing could be=
 done
> >>>>>>for OMAP3 and AM33, then we would have a chance of having working w=
ake
> >>>>>>from idle with the new irqchip.
> >>>>>
> >>>>>I can repost the current series as it stands now once 17-rc1 comes o=
ut
> >>>>>(without the build failure ofcourse).. if that helps to move it out =
of
> >>>>>RFC status.
> >>>>
> >>>>That'd be great. It would be ever greater if you could add support for
> >>>>OMAP3 on that too.
> >>>
> >>>Yeah sounds good to me. Tero, does that work OK for your PRCM changes?
> >>
> >>Well, this set seems to break PM. suspend-resume on omap3-beagle just h=
angs
> >>after this set is applied. Works fine without it with 3.16-rc5 tag.
> >
> >did you apply the quick little hack to prm3xxx.c ? prcm IRQ is hardcoded
> >to 11, once we switch to a linear irq domain, irq_base may change.
>=20
> Yea, with that hack it works. However, you should make that into a proper
> patch and add it to this series, otherwise you will be causing regression=
s.

can you please read the thread ? Nishanth has a proper series properly
doing that for OMAP4, I asking him to add OMAP3 and respin his series
without RFC.

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT25v/AAoJEIaOsuA1yqREiS0P/AoGDhuqicj/49uoLHq9d3L7
88m2hoTIGMD5TM7xuYWCYK23YNnE/j8/gcDAGyctc73lbytzVU0Y12ZK7XOUji2u
iz8GhMz2Q7fxjBCJYB56CbiZYCqA4mycezXgHNShuVXDQQJb/sqjLuoIih1Cdd2E
nsoA2axA/IjbSPbH/VYEKroXIX7vvInZlH0oQVEegM1F/XRNcHoUq8ColWqkw9Hi
7s6LgX3Zxv7zFJEOywElR659XZ9lbBMZeewGQoOOk3NcjTqWhXT8st/I/Mc1y8cq
Vusaoj7av0DImJJTqGf8mRn92zR95RpIVUWT/Z/mEuyEC2zgjHV6XKxqpA77HWi0
Tp5IsXA8ihkIfgco3PG5JPBrgUQ9muhT8tixGuXFur5OSK5ITVqJyOaj2Ixu1Iyp
yYsvtPBzhqY4dHTcMHR2u3TB9zcrxZLKL24rOyvj7RHxTXli9srFN96l6wMz4dx2
mozYkhimVqZjdOdRXvzD3gq0Efd/q56Y8U9EtQBhzNhq7llqNtoZyrpxJHW4co7t
4Gxns5BLCx2C0ixDftKSnsZiFGO0VEvJ62fscEeGnSgBf2AucFBIkPcOdCrh2PSh
Mh+3E7HD/btyfoMT7DcKPIJ4WMaDJsSpf8xLuPKLordwaPpoh3ZSiMio46Gp0jMV
LKOANSX5dyXjmVMpuAR1
=Mbkb
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
