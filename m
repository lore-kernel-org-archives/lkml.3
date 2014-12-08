Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaLHQ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:29:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:24915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaLHQ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:29:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="asc'?scan'208";a="495510884"
Date: Mon, 8 Dec 2014 21:58:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208162843.GP16827@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
 <20141208141807.GC8739@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20141208141807.GC8739@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 03:18:07PM +0100, Maxime Ripard wrote:
> On Mon, Dec 08, 2014 at 11:47:46AM +0530, Vinod Koul wrote:
> > On Mon, Nov 17, 2014 at 02:41:54PM +0100, Maxime Ripard wrote:
> > > Hi,
> > >=20
> > > As we discussed a couple of weeks ago, this is the third attempt at
> > > creating a generic behaviour for slave capabilities retrieval so that
> > > generic layers using dmaengine can actually rely on that.
> > >=20
> > > That has been done mostly through two steps: by moving out the
> > > sub-commands of the device_control callback, so that the dmaengine
> > > core can then infer from that wether a sub-command is implemented, and
> > > then by moving the slave properties, such as the supported buswidth,
> > > to the structure dma_device itself.
> >=20
> > Okay managed to get this done. Apart from the two issues identified did=
n't
> > find anything so applied and pushed to a branch
> > "topic/slave_caps_device_control_fix"
> >=20
> > Today did some compile tests and found few warnings, were trivial but I
> > am worried about the testing of this code. Has anyone tested this, if so
> > which platforms are covered Since I pushed base branch last night, Feng=
's
> > bot covered it and all was OK. Looks like Feng's bot doesn't have wide
> > coverage of arm platforms, wasn't there one run by arm guys which tries=
 to
> > test and boot, if so can we get this tested there please.
> >=20
> > So bit sceptical for merging now. I will send the patches which I have
> > applied on top of this
>=20
> Which is why I wanted to merge this at the *beginning* of the
> development cycle in the first place....
>=20
> These patches have been sent more than 2 weeks ago, and were exactly
> the same as the ones send at the end of October, rebased and updated
> to take into account the drivers that were merged in between.
>=20
> In short, these patches have been hanging around since 6 weeks. I
> relied probably too much on the intel's build bot. This is not a
> mistake I'll repeat. But blaming it on me because they came too late
> is *very* unfair.
as a first step one is expected to compile the patches we send. That is very
basic stuff which should not be avoided. given that we had build failures on
v5 rev of the series and serious failures flagged off by compilers doesn't
inspire a lot of confidence. And lastly noone blamed you for being late, if
things were rosy they would have been merged over the weekend and been in
today's next, but...

--=20
~Vinod

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUhdG7AAoJEHwUBw8lI4NHeGUQAKgQ/mtIYvo6qMkHmEh+KFTu
Ab1xc+3aIOHLHXpaOdtzKmiqf5jEFt9lDItZiRwpQNJcOC4NHFXSkHiN8cuX2VpS
rsKP6TEXp7CfXtVN/RPK7OobsynlNNCOylUjYazHe3Y5i/IXbEMhJ/+S1MSLXWmA
8WybN1FrNVBTMfWDR/a5momYK3sIyIeYs9BrOCGrmJkNifcm7/lhJJOUMFHtTaSx
sKz5u1SzWAdIViUNPrrvwrE4KBFLMM54lQzTR7C62q1Yk3M0LLCMH66PoUj9nNoO
0yXvI+Qp6S0n45upJdrL3eoo3egNuiF26Xi2hyCcuynBnw+2Rr5dRcCDvZaiTBvl
/rZVM8DQLTY93BuGRqehTbltLBRfrTkYULjGtdrktFdA0u+G7VXJXL3AKk6o9TaQ
rejnhR42kJQDlexV1qnqA9DaVHVw3P3qyXZpZko3ZHRixEjVc7RRHH3mlOJRJNxq
DcIaR6e2VJORQpQoDXJfTv5yNzWk1gdxJetiRIxzokibTlYb3TWOoLuvwy7G4wqi
c4JJZKdq35ttLaX5HylkuaFSLmCL2gB89PQQj1P2JQCllQUVI2KD640P7zhekMjw
z/aqiHvDjz1izXXMwYCGLOUVpeeq9XuAKIAIZghS21NvkL4F2JFLSK/li0YMfXfL
HlzhCq8vLqPWV52XDKek
=o4CN
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
