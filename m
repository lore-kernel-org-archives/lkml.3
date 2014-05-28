Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaE1PU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:20:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaE1PUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:20:24 -0400
Date: Wed, 28 May 2014 17:20:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140528152011.GX11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140528135617.GA25750@amd.pavel.ucw.cz>
 <20140528140632.GH2570@moon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjRHIBfqI5bf54wl"
Content-Disposition: inline
In-Reply-To: <20140528140632.GH2570@moon>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fjRHIBfqI5bf54wl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 06:06:32PM +0400, Cyrill Gorcunov wrote:
> On Wed, May 28, 2014 at 03:56:17PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > So just to be difficult I fired up the perf_fuzzer on a Pentium 4 mac=
hine.
> > >=20
> > > It crashes more or less instantly (sorry for the line wrapping,=20
> > > just got the serial console hooked up and don't have minicom configur=
ed=20
> > > right yet).
> > >=20
> > > this is 3.15-rc4 with the anti-memory corruption patch applied.
> > >=20
> > > [   67.872274] BUG: unable to handle kernel NULL pointer dereference =
at 00000004
> > > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0=
x331
> >=20
> > Pentium 4 's were not 64bit, were they?
>=20
> Not all, but there were 64bit varians (Xeons iirc).

http://en.wikipedia.org/wiki/Pentium_d

consumer netburst chip with x86_64.

--fjRHIBfqI5bf54wl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThf6rAAoJEHZH4aRLwOS6wKAP/0GrQlaTgkXshTS3698dYlNF
tiSjB6f85eHRh75jhwxO1MqW7O5x9sMPIlcYSJMFblOo5T23APgRdHmpP9/G8eg2
ZE+RBC6jC5kp6hhF0N9gE/0RZKLQ3+y7YW/Bynp/haRHww1KTu/0xRWP+75pVX64
Z6ublwI7U9CB39Oupe5HB6GGsofG5r+1jaGuvz4AcY+NNVCJeYFpkIKWjfEu7HKn
y7TbHymS2sNc1+vPPQz/NkbGbhXQqz8NGNGUi/6be5Xh9wttSm0B7Ls5sTK1kdRW
uIPgyvfRSqCO+QPM3gjogLKG6a+rx55GUlblODt4V14qdi4hbZuruADvxb7fSGkn
kDS25onwoK5KvVZh7OC10vwfN7DezpGhc4JajhkxiQc927kT7/ULPst/XOvtdciC
vAwzct4zugf269aPPi2NoQ/rIDcHCAgx1qN5ZZJo57msse+I3M2obeUkOfxM9hbl
bhv5yds0IUDcMjVCfh5kK+/KAM7YoNXaGY78VpESygISjmdSwsgIPJ5NJKDaZS+j
hVeO6om/ZmOg4wnl94AlGTXzsNV6npNm77VQzUW1Tkgxk9jHNQWHX4doRQD3zcrL
awxRhlqH1GMKxmUpnM/aowIWZp3b0k1E6SZrcg0plwxM4wmNKgMLaHUpPVNUiFVx
s4ksJrYUq5CB4FbMOTFo
=BlZe
-----END PGP SIGNATURE-----

--fjRHIBfqI5bf54wl--
