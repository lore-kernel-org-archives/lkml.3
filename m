Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaE1Pgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:36:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaE1Pgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:36:39 -0400
Date: Wed, 28 May 2014 17:36:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 5/7] perf, x86: use the PEBS auto reload mechanism
 when possible
Message-ID: <20140528153633.GZ11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-6-git-send-email-zheng.z.yan@intel.com>
 <20140528075937.GO11096@twins.programming.kicks-ass.net>
 <20140528144643.GG29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXCyug6VAL2FbtaR"
Content-Disposition: inline
In-Reply-To: <20140528144643.GG29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fXCyug6VAL2FbtaR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:46:43AM -0700, Andi Kleen wrote:
> On Wed, May 28, 2014 at 09:59:37AM +0200, Peter Zijlstra wrote:
> > On Wed, May 28, 2014 at 02:18:08PM +0800, Yan, Zheng wrote:
> > > When a fixed period is specified, this patch make perf use the PEBS
> > > auto reload mechanism. This makes normal profiling faster, because
> > > it avoids one costly MSR write in the PMI handler.
> > >=20
> >=20
> > You can't do this unconditionally. Like I think you mention in the next
> > patch, we need the PMI to fix up lots of cases.
>=20
> There are two cases:
>=20
> (1) Fixed period specified with PEBS.
> The PMI still runs with threshold=3D1, but we can use the PEBS
> auto-reload mechanism to automatically rewrite the counter which is
> faster.
>=20
> (2) Free running mode with more constraints
>=20
> This is case (1)

Sounds like something that should've been made clear in the Changelog.

--fXCyug6VAL2FbtaR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThgKBAAoJEHZH4aRLwOS6pdIQAKQx3coUboLjlJwBCKapS99M
UdGeUzEY1m/RIIWm7jGWgomWiE46xQa4PUT1pUw7xnFEVE8USlc5vshoJ5Ym2S3D
fw41DfVY+2MThybgJWFL3whU3a1QCkGwSIWahSQZ0gk0X+xKa2RLVI+u14Tfjhpb
tOfgKE74B2pyL5e8gal67LU+W79uTCVh9KQtnlbSjN3u8BJioRZdEpmATzUI5p82
lriZA3pRRmRtAMiTURGjSTLENpg7VBgxOQH2nzFmW18FunkNbUuuE+lQeb1FVITJ
JtK8a33eC+wbjZETEKDPTiJRDwIFa1DQW12OxXKlaB+JraXX1UlHVLfnnN73/6hk
1sZENze2Wcb54iHCopuKA2l3WOPhEtequakVgS6WI3bwY93Ek9+l6cSY6R28QyHc
WsYkQjUZ4Y5t+1FQjCQo7ZPxhYVAosRHJa9W+qM03n/CABO411CzKiqxEkk3G8SP
Z/DWMGi02hv85Bbo4sMHwmpUPnv6L7wlNpu1RXBPVlANT9Dw7RRHEixIC5oM1irz
sOwqq9x+9y0dNoXWsBFmCrZGBOURIUvwiJmJE1wpELHNA1lTUaqYwKCO32M1cqhi
Ni+B/Sms7DrQ5QYV/IVUJmmjy3RUgakwSKFT8gM6lgQdAKUaK8sT3x60+haiO0FL
HZqKM8n2cBqNAGUlBcuo
=9uEu
-----END PGP SIGNATURE-----

--fXCyug6VAL2FbtaR--
