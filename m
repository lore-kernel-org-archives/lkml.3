Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaGOQQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:16:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:58258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaGOQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:16:16 -0400
Date: Tue, 15 Jul 2014 18:16:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V6 1/2] perf ignore LBR and extra_rsp
Message-ID: <20140715161607.GN6758@twins.programming.kicks-ass.net>
References: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
 <20140715151130.GK6758@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014F0CF3@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OqG5N5f8gK0cTFut"
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077014F0CF3@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OqG5N5f8gK0cTFut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 03:32:36PM +0000, Liang, Kan wrote:
>=20
>=20
> >=20
> >=20
> > Since nobody ever treats EVENT_EXTRA_END as an actual event, the value
> > of .extra_msr_access is irrelevant, this leaves the only 'possible'
> > value 'true' and we can delete all those changes.
> >=20
> Right.
> > Which, combined with a few whitespace cleanups, gives the below patch.
>=20
> Thanks. Your change is perfect. Do I need to resubmit the patch to the ma=
iling list?

Nope, got it queued.

--OqG5N5f8gK0cTFut
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxVPGAAoJEHZH4aRLwOS6XZcP/0MTRYYe/o2LtyrmzH/meB7D
k7kTWESdgtdU7QuLEpDDjTSyxIxK7BhLhGfafZ+x98J9mreJ+ASO59QEAxee4PPP
cds6v1UOMX2SqLysdzyNJkiG0BTtFIDDPNOtOa1eRODggjzeAyXlUHYyQiP9F5jT
GiymcsQAIO1b3w6qr8K0OCmRFA1zKmhyZfgYco1EpPpHRQvnJ5OM1BunVjD6aZLw
ce8Gss6fIO7vTBrneLAl+dqids9TsRWvhnm/OPSTr5xM6xv/Wqfg2TxtwP1uTX+B
8cHv9C2sP0S05XmYe5gbfU8H+QgE+wntEZaxLj+QhkIubkgl/7jQejuAsfGU/BY8
LZacNS25kDnWqi9wUlXC4ZFjHEDXDCQeVx/kNFcI9XYfZxj105JispJtQMCtaY+B
mBU8OGI5EAuuniKm4tfHpR8sVfdnfEMXPHoLP0rJhOmTerT64x9lcMY601+0SYte
n8xfYAxhDdt2UxP5mMWf+z+IBszBydEexfrn/leX7BAtrbggKXwfC8sjznns3zkQ
9KHOxaxSRZKfzO8UNpPqkXAT52PMscGZxyZ0s3Ro/kVkWPrGzx5tXMdtK4Iio4dh
ovbKqNF5xOemRPiD8wKCjgxPWNk5MhTfuaIn1UtGDbtJMINbmwB5wnZU4sgEbhac
IxGd9qy8Kqkvpy+9owBx
=t9Ei
-----END PGP SIGNATURE-----

--OqG5N5f8gK0cTFut--
