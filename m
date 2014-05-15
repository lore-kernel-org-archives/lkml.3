Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaEOI5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:57:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaEOI5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:57:30 -0400
Date: Thu, 15 May 2014 10:57:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140515085721.GH30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140514170238.GB15690@htj.dyndns.org>
 <20140514171051.GX30445@twins.programming.kicks-ass.net>
 <20140514223648.GH15690@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wqp2XNkat9H91DRI"
Content-Disposition: inline
In-Reply-To: <20140514223648.GH15690@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wqp2XNkat9H91DRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 06:36:48PM -0400, Tejun Heo wrote:
> The patches are URL encoded.=20

*sigh*.. evo used to do that, and now I think mutt does it because I've
set up the whole GPG thing.

All my scripts already automagically decode it so I hadn't noticed.

I can give you some awk that undoes it if you want?

--Wqp2XNkat9H91DRI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdIFxAAoJEHZH4aRLwOS6vj8P/2v4mLOBLUTDcgQxQFHF+XxH
LIbILxux6zgCBRrBdoFkqhwiBhvXD51iBXAfTIORK30rRcjvl7pjYc7HrZaBep72
gw9JldIlVa5yOYHerGWAGdn/B6Vn+71UlOWBODSbBCYGFs8Kf93k2mfDEBUqpIWf
UIez/aBJQoChFe3yBNGa8D+nBdfBhJcq+BM68ifVTnBhRr7JcW2ENrmUax5TBSky
u4u/sWZckt6L9kKJ7W7GlceHTVRTH1EIYX/Qy9RNzm8mpmTazL5Tx9bV8yKbdWwE
oi+5BIO+yJkuvcHQBkJS4pb4JB9rxTCQWY0ts6aP8iYH1aWKSSNHz0wys5MkPGWz
fXB+O3izvzEYLFrp7y5tGBign5XY6GIhj3D6kLh5ApjJJ2LEzM5gMh3GYz0dXtxj
UroUC+FljeH1XBMmTsFBOCvQwG0uswY0OiJDHsAbFyfg4L5T+NWCbwFkjZS97DyE
9Cvf459Ste1EoFv2OhESG4sAGETf5oQl8l1Ci47QICbTG3dc2ml1zVN1PhzJBUxr
WFGu/Rx9SW5JkUNurihK7/alaYdyYB4/zap8TmgwFh/Pmo2/Aia9/lz5pjHEf7LB
U+XrvVWKU52zPTWTgO2oEQmm/4vwQATiUIGRsYoAKID8MmISdF0fFn0QOQlR/XFP
G3dMGlj/ANdLV/Y/ETKk
=//ZJ
-----END PGP SIGNATURE-----

--Wqp2XNkat9H91DRI--
