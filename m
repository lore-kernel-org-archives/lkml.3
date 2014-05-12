Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbaELPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:15:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbaELPPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:15:38 -0400
Date: Mon, 12 May 2014 17:15:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com
Subject: Re: [RFC PATCH 00/12 v2] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140512151532.GQ30445@twins.programming.kicks-ass.net>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
 <20140512064533.GH30445@twins.programming.kicks-ass.net>
 <20140512012856.GA9351@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4CI+obvDyVe27XRB"
Content-Disposition: inline
In-Reply-To: <20140512012856.GA9351@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4CI+obvDyVe27XRB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 09:28:57AM +0800, Yuyang Du wrote:
> On Mon, May 12, 2014 at 08:45:33AM +0200, Peter Zijlstra wrote:
> > On Mon, May 12, 2014 at 02:16:49AM +0800, Yuyang Du wrote:
> >=20
> > Yes, just what we need, more patches while we haven't had the time to
> > look at the old set yet :-(
>=20
> No essential change, added commit messages (after smashing our heads to
> figure out what general code structure is). Can we get over immediate no =
go to
> maybe slow no go?

Well, sane feedback means I first have to read and digest wth you're
doing, this means at least a days time reading through your patches.
Finding a spare day is hard when people keep sending me bugs to chase
down.

It'll happen, eventually, but you'll have to wait, just like everyone
else.

--4CI+obvDyVe27XRB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcOWUAAoJEHZH4aRLwOS6Vl4P/13hIYg6ZqzyrtdGq2D8SLxj
pR+yXy7rT/0morcjzi9WRacYusTjGSF2o71wXnV403IwjVXYubIlbM5TaT3BQ/aD
/x//AX1UFQCdOWf++Kn0svxG3SsEzDz+QZXrh7G45usArji+taI6G3Afm0F4KWGj
Kz07KOiddoci7eBR5Nx+tFHDrS+t48OrAejdwr5VzdR9Chn0LF4m6USNaJOWsH6a
kQCD+7DyewbBbMZja7ouDFkg9JlgaFarwHEbo2i2ww8HH4TtYrRqDGpNLDNosb0P
HEQRlDK/9lpEGGiaV6vyz+xIwSJOyST2+DheHMbQip0oBcQB3pAgN3mDIOoyzhZD
9liO79hduCXFdMY/AoyGkyIbRQQJlPfIasIdwQ6Uc03/P/cVW0MXDNsoDvrEQy5A
NcbZEedOR1JqgGQcNM26CeGp3BQakqi6liCezob46/vTEDshe6cJhG0KVTIhzPy/
jXer4EpRNAqS9hadeXPWIfmwhND6FTnz9FypUVY8G/qLLSKBIBuvBboJoiEtes6D
WnY/SxHNR7Nv/Edzy6lv5IEL1kZW2eaU2aCe+iHuswvcPaqv65xfYCqRYSJM0Tdz
O51CFalB4oJLxpamSmY2ia4UawxOLEaq/W8RF36SWZqJAbrnpji8A7o69i7kv17l
OYUHoDBZp2+v7B7DXT9+
=9cUc
-----END PGP SIGNATURE-----

--4CI+obvDyVe27XRB--
