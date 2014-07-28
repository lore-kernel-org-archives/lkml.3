Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaG1Ixu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:53:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:57950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaG1Ixt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:53:49 -0400
Date: Mon, 28 Jul 2014 10:53:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH] perf/x86/uncore: split Intel uncore driver to smaller
 files
Message-ID: <20140728085337.GM6758@twins.programming.kicks-ass.net>
References: <1406277655-21808-1-git-send-email-zheng.z.yan@intel.com>
 <20140728075623.GP19379@twins.programming.kicks-ass.net>
 <53D60459.8040702@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JFnjb9gtssGV5AzD"
Content-Disposition: inline
In-Reply-To: <53D60459.8040702@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JFnjb9gtssGV5AzD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 04:05:45PM +0800, Yan, Zheng wrote:
> On 07/28/2014 03:56 PM, Peter Zijlstra wrote:
> > On Fri, Jul 25, 2014 at 04:40:55PM +0800, Yan, Zheng wrote:
> >> split Intel uncore driver into four files:
> >>  - perf_event_intel_uncore.c: general functions of Intel uncore driver.
> >>  - perf_event_intel_uncore_nhmex.c: hardware specific code for
> >>    Nehalem-EX/Westmere-EX
> >>  - perf_event_intel_uncore_snb.c: hardware specific code for
> >>    Nehalem/SandBridge/Haswell
> >>  - perf_event_intel_uncore_snbep.c: hardware specific code for
> >>    SandyBridge-EP/IvyTown uncore
> >=20
> > Did not apply properly to tip/master, also can you do that in 3 patches?
> >=20
>=20
> the patch is based on tip/perf/core

Hmm, that should be good enough, didn't want to apply though, gave a
massive rej.

> > One breaking out the nhm/wsm-ex part, one breaking out the
> > nhm/wsm/snb/ivb/hsw bits, and one for the snb/ivb-ep bits?
> >
> will do

Thanks!

--JFnjb9gtssGV5AzD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1g+QAAoJEHZH4aRLwOS6vO0P/jFUumn3V1EkN+FvX3rpqLUX
KaNMzkkoBA2aKYYbhBPxA8Ud4EgIq1sHb3627V/U9J1sK/Dka4MnwLPhimkCg8Q9
ykA1pg6NEGBnh8dafEIHPJTQQgRDUAq5PLbtTt9ymTcwc49THa/26cnWLWgGbk4T
inQ0tjtx9vqbIH6v9BgJY9qfeZjffk+cPWQ9+ctPo8VDsxl6Tukx4YlzUWDunNrR
4U8AzdJN+U1opjzvD9odXmWkdWL/AoKb6dzBIpj3l0WD3mwIHeO1jf1XJvhimeFM
36F1dSEOBu82yIh2J2mlyp/FA0RPgwqCEt1ZUjiL4djmaDWExHWyNm3G+emSMnqJ
olRT96QtkaFWYMjT2jKvMdOxoFuZOTfOtmQVPsLiWAH57mmT9Tt3vI/kpS6gpV3D
cpYKgA3qKbu5sxNo7ra4WTzly7kpazsAMg7q3I+fca3Ce6kNTnGxtthUKY2IJxm3
vH+qIqfc3tK3bJSOd0HydzZL+PcGzO4MagXRhs0DH15n8OJ3ET4PcPNdk+Tdg/Ro
iSv58dMLrstBQAsd8IvGbW2XsOFPwKhKSN8o0jrjd/ZgcNZLu+qRmPvP9Cft6Hwr
T+Ff7iYW1GcAGf7jOM3q2aKEe6wcyGil7c9FbOvzQyIMaWJUQnu5MdBJWZGsCqES
L4wLt5aArIBsWaZ0LwLJ
=l2Fl
-----END PGP SIGNATURE-----

--JFnjb9gtssGV5AzD--
