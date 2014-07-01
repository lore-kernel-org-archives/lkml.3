Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbaGAIUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:20:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaGAIUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:20:39 -0400
Date: Tue, 1 Jul 2014 10:20:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
Message-ID: <20140701082020.GL6758@twins.programming.kicks-ass.net>
References: <53A11A89.5000602@linux.vnet.ibm.com>
 <20140623094251.GS19860@laptop.programming.kicks-ass.net>
 <53A8F1DE.2060908@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="afaOoWBOIwPZGAW2"
Content-Disposition: inline
In-Reply-To: <53A8F1DE.2060908@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--afaOoWBOIwPZGAW2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 11:34:54AM +0800, Michael wang wrote:
> On 06/23/2014 05:42 PM, Peter Zijlstra wrote:
> [snip]
> >> +}
> >=20
> > Still completely hate this, it doesn't make sense conceptual sense what
> > so ever.
>=20
> Yeah... and now I agree your opinion that this could not address all the
> cases after all the testing these days...
>=20
> Just wondering could we make this another scheduler feature?

No; sched_feat() is for debugging, BIG CLUE: its guarded by
CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
broken.

If people are using it, I should remove or at least randomize the
interface.

--afaOoWBOIwPZGAW2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTsm88AAoJEHZH4aRLwOS6v1UP/RIwNax+7sBxk5ksNCiuKdDb
znNgTbnIGZpsUixxy0mk6NDLdM4NJM8K4Mf0ey8J+IYR9TjXO1cJK65M1qB837F/
2I1bwBU56khhbNlGioMctKO6uUIJO8FpUgbLctfQmSY2Ts1eWAlIlRi/Tmtf1Z2n
PeaC8DmnrqtIwFOQtk4rWpvcgqRgQxTOzq9CtpdqN/cAi20GSRfnHjp0bI4ZvwXp
fRPXQX/N5UimaGS6hIvQ41quVlhJ/Rv2DGZw4oaio+tWLMx9V0fmjAfNJuVUf2hr
Wald4Z6DYiRVGgZZWCia8/ySHqiXiLytOUNbWO+Dc/44g0LsLv9FDl/1WSYIzXQv
haF3eqy8qSa9KzsN3xoQj/W7ZFmpAKynLWC+huWkHHuLYmvWMcZqZr4S3Oz4+dkK
aP8vyFmQELk2GC9tLHH3gnWnRLPtilYM3RPqM4lxZMSEy8NgerkNPGE44v3a9gi4
+SMZYpZ9dxV3+W/yk+ir3g0pKFhl7mGUh3euCC6Vuvd6PQLCIXSeuPUiqAQrVdhV
CaWV6r4tOSco1nGV/tKUCtBQe2SbGPnBk+OFN8xQXLCpcVPaADkgd/dwV7s1wdme
FmbJjo4KXqOn8XSjzctWq0POqrx4mZynx0F67ZXlx54LPZIvlC5I4nSIB/HqLIMM
kDagxRxaZUnXJyE/4BH1
=oegg
-----END PGP SIGNATURE-----

--afaOoWBOIwPZGAW2--
