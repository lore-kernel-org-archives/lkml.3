Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaEPHy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:54:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:37013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbaEPHyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:54:25 -0400
Date: Fri, 16 May 2014 09:54:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140516075421.GL11096@twins.programming.kicks-ass.net>
References: <20140514094426.GF30445@twins.programming.kicks-ass.net>
 <5374387E.4080802@linux.vnet.ibm.com>
 <20140515083531.GE30445@twins.programming.kicks-ass.net>
 <53747EE4.3020605@linux.vnet.ibm.com>
 <20140515090638.GI30445@twins.programming.kicks-ass.net>
 <53748A5D.6070605@linux.vnet.ibm.com>
 <20140515115751.GK30445@twins.programming.kicks-ass.net>
 <5375768F.1010000@linux.vnet.ibm.com>
 <1400208690.7133.11.camel@marge.simpson.net>
 <53759303.40409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+1hRa/9CwYN9i9M"
Content-Disposition: inline
In-Reply-To: <53759303.40409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+1hRa/9CwYN9i9M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:24:35PM +0800, Michael wang wrote:
> Hey, Mike :)
>=20
> On 05/16/2014 10:51 AM, Mike Galbraith wrote:
> > On Fri, 2014-05-16 at 10:23 +0800, Michael wang wrote:
> >=20
> >> But we found that one difference when group get deeper is the tasks of
> >> that group become to gathered on CPU more often, some time all the
> >> dbench instances was running on the same CPU, this won't happen for l1
> >> group, may could explain why dbench could not get CPU more than 100% a=
ny
> >> more.
> >=20
> > Right.  I played a little (sane groups), saw load balancing as well.
>=20
> Yeah, now we found that even l2 groups will face the same issue, allow
> me to re-list the details here:

Hmm, that _should_ more or less work and does indeed suggest there's
something iffy.

--m+1hRa/9CwYN9i9M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdcQsAAoJEHZH4aRLwOS6CtgP+wSYPapAla0sj7jNnseitET4
a1PDVxe5wAF5lur3c1blyoREJCChfvaqigW+C+jHApuFqDXmnB8fweZvE8NmX/4y
vdGTB6Qql0Z+3Ymld+HYSyNfhWzsa3aQDSlCIwm8XZ5RGVHtkPr7NxXfweE0G49Y
QDcREVa9Z5vM/Te6pHnRDCVa2jBjHsO22m5USdY7Hcl8d+xXJImXNUGvXvOYk92m
Q8cnPyEeUGr+n4jnwxwUWiIhWv7S8R40RjqHxji4VEFhswdidPZ8WEro39L9NF/Q
isbAEntIoN02OIi6e33KZtIm6uUFIM4Y5RehpWh3Iy57kjuct5MvVSwD4K40oFGj
U5jED0WVRA4rwDWR4Kr6HWExL0HO0b0s61ehtqpJjlK6fLKPQL496MuB4b1eK74p
UPacU6YvPDSkPJ0cy7vAlW1XSNFzZn3vN7pluiHHVUXsROJYTDavz+SxmcBqrUy1
a6i/XJz9BB8DI2BXuAHocrkYwZbHq7g3HaBTpMBMl4dyVPssuCpDvNr+TGLjLilY
xvgkRpVDfDEdlZDDkD03PXTDMCYc20Qaavpzy4hBSTamb/B2yT6xJ0I5X7/EHnT9
RUmLYjWkmAezRRt3+Pn2d5eCir4B0O3MIgCJu6AuKZYl9NybgaSS0aJnFiIAIbYZ
/Lcj2kkp5DZIYPFyKQ+D
=3QMI
-----END PGP SIGNATURE-----

--m+1hRa/9CwYN9i9M--
