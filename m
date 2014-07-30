Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaG3IaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:30:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:41622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG3IaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:30:21 -0400
Date: Wed, 30 Jul 2014 10:30:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140730083008.GD19379@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
 <20140727173616.GA22986@intel.com>
 <CAKfTPtBR1dK-8nFGAMvEa2AC6ByZgOskkZpWEOXwzDrUD6xBDg@mail.gmail.com>
 <20140729014343.GE5203@intel.com>
 <CAKfTPtAj1sye899ac5eMwgrHOLbGmrQhmRK5xEF3s2W6y0BReQ@mail.gmail.com>
 <20140729222752.GA28673@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PScnVrM2Sox7GiMT"
Content-Disposition: inline
In-Reply-To: <20140729222752.GA28673@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PScnVrM2Sox7GiMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 06:27:52AM +0800, Yuyang Du wrote:
> On Tue, Jul 29, 2014 at 03:17:29PM +0200, Vincent Guittot wrote:
> > >>
> > >> IMHO, we should apply the same policy than the one i mentioned for
> > >> task. So the load_avg of an entity or a cfs_rq will not be disturbed
> > >> by an old but no more valid weight
> > >>
> > >
> > > Well, I see your point. But the problem is what matters is load_avg v=
s. load_avg, not a
> > > load_avg itself. So, if load_avg1 discards old weight if weight is ch=
anged, but load_avg2
> > > has no weight changed or has weight changed, the comparison load_avg1=
 vs. load_avg2 is not
> > > fair, but too impacted by the new weight. The point is, we count in h=
istory, so connt in the
> > > real history, which is the whole point of why we count the history. M=
ake sense?
> >=20
> > IIUC, you want to soften the impact of weight change on cfs_rq-> load_a=
vg ?
> >=20
>=20
> Yes, that would be the effect.
>=20
> Isn't the entire effort starting from PJT and Ben up to now to soften the=
 extremely
> dynamic changes (runnable or not, weight change, etc)? Assume task does n=
ot change
> weight much, but group entity does as Peter mentioned.

No, softening isn't the point at all. But an integrator is the only
means of predicting the future given the erratic past.

The whole point we got into this game is to better compute per cpu group
weights, not to soften stuff, that's just a necessarily evil to more
accurately predict erratic/unknown behaviour.



--PScnVrM2Sox7GiMT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2K0QAAoJEHZH4aRLwOS6mhUQALNd10oqcLV/veIYP3+MpDka
+zKl1tn8cURWmiI4ynyv93AuBk5yA3s6lkkhcnqjj78AD75O3MwcQM5WHYXGhrpN
ht/NIwY9fbWteWAArJ5lxrDXid1F+JrFsz0W9BRfZTh2UWTCUIDYOLyC9CaB5LIE
rL+z6nzcmEzint1hTLNi0bEXnap1/++ANQtADcabZVaSD/tgrfnHOmZR4abHQRvL
wXqlqhnU745qYY57YXZZuBDHlYtG45q5DQe+c8kynp5m7bl8Enqggfiaehtugzq8
yw1/ZfbL1xGB1zcmHsLdHdM0zh7KWFncrJgGWAIMxfwC8ZfXkYrs3earSNEOUEVi
nS7aPUqm8YU/ocHvw7fSpiid9CLB0V61qEL99QS7LiKQYGpP0QJNRDu3NiCWvwEg
pfq8+1eB++BOVfKz73ZbkiCWBIjcD+LIQUs1Yb25A5RNwrrrvfnhl+4fBV1Bjyyh
1tECr3ffhc70l1KW/1gUaRgseJOq/nF4c4ApfGEkk2pg0JgSzj3VVKDDpwoZgRXI
m84HYAkinhdkTH3JE2k9QUZAVh1Ij7E3dSGAzGZywOisJN5YmJSlEZFSiBF/nc1W
90yVSV5bkSqqqEkdP3g8Q3qedAAe/LY6fFkhBskxBusiGRU2IIPnolkZiLsy8s4a
UynxS+LrZOooS6JQIkFh
=7+Hy
-----END PGP SIGNATURE-----

--PScnVrM2Sox7GiMT--
