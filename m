Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaHAHaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 03:30:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAHaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 03:30:05 -0400
Date: Fri, 1 Aug 2014 09:29:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org, jhladky@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140801072950.GF19379@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140801020330.GA30211@aaronlu.sh.intel.com>
 <1406865802.4243.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1mITeCFf8ikHEgLU"
Content-Disposition: inline
In-Reply-To: <1406865802.4243.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1mITeCFf8ikHEgLU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 09:03:22PM -0700, Davidlohr Bueso wrote:
>=20
> Instead of removing info, why not document what each piece of data
> represents. Or add headers to the table. etc.

Yes headers are good, knowing exactly what a number is often removes a
lot of confusion ;-)

--1mITeCFf8ikHEgLU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT20HuAAoJEHZH4aRLwOS6rk8QAJG6vkGUHW39YSQK/68ZAxZR
u68VYgxdmh5cq/DRBpqR4C3WMxOf+All65DN9EdGEfV2x964qBWWA9Ie3SXr1kyF
/C/3m/D6JrFLuY62PnVNCKysjk5AeoVWdEgeBLGq6E3zFzrgN8i4P86zrU7clWCm
z56AndMhVtbWrCzIBRfn4MxsFKU3jAHIc/5BYsvv+Mjdy1f8c2l4OyCuhRtCasL7
6syurAuZ/raAE2ECkN91OYZzOmZKebJe7IzluZk4I610QdqEyna/3RMlWKm+WQFB
jHhw8+ZgFJREvFAWkDkjB+5TYeX0R/xBRVnSFKL1QRRA1wbDevcOQ36d6YZrB1Pn
hn7YdfeHlu8NRwJjxO8cyQbR7Tokf/H5aTlda6bUnoFixtLRfZDUHoOLbYh/mH3c
xRRDp3iyQY1iaJsMBQk+W52FAa0Hx0eU7ifFlFeWqwkcHsZLT9s4TsCStAx6upOT
qVrVuDT+xhWPXo/D2aNTprvekdfECDajmt5FGtpFdkD7NVTmgXIbS5E9rbyA/8qA
X6R69gc9jngDwpWsl75eqRafhqBNXN2I1ZgV+GSqjN9fkE90/pDlDqX2ljmN0Bn8
9415HYrBIt1HRA/n0UAVe3wpVDnSvcF4KVSoRkdv6063rjdw0kgDcsUXuasd5OHV
wSZ6Io77YbA9ywyq7p6Q
=jPjD
-----END PGP SIGNATURE-----

--1mITeCFf8ikHEgLU--
