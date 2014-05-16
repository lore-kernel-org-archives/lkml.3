Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaEPPpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:45:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:40345 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaEPPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:45:44 -0400
Date: Fri, 16 May 2014 17:45:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, namhyung@gmail.com, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/6] events, perf: Pass protection and flags bits through
 mmap2 interface
Message-ID: <20140516154538.GW11096@twins.programming.kicks-ass.net>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-2-git-send-email-dzickus@redhat.com>
 <20140516122219.GQ11096@twins.programming.kicks-ass.net>
 <20140516133300.GO50500@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="34/PV/2fFpU6TJrn"
Content-Disposition: inline
In-Reply-To: <20140516133300.GO50500@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--34/PV/2fFpU6TJrn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 09:33:00AM -0400, Don Zickus wrote:
> On Fri, May 16, 2014 at 02:22:19PM +0200, Peter Zijlstra wrote:
> > On Tue, May 13, 2014 at 12:48:12PM -0400, Don Zickus wrote:
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >=20
> > > The mmap2 interface was missing the protection and flags bits needed =
to
> > > accurately determine if a mmap memory area was shared or private and
> > > if it was readable or not.
> > >=20
> > > [tweaked patch to compile and wrote changelog]
> > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > >=20
> > > --
> > > Peter you mentioned writing up a changelog for this patch, but you
> > > seemed busy, so I jumped the gun a little bit.  Let me know how you
> > > want to do this patch if this approach is wrong.
> >=20
> > Oh, right, totally forgot about that. yeah I think the blub you have is
> > adequate.=20
>=20
> I realized I didn't put your sign-off even though I said the patch is from
> you.  Should I repost with that?  I don't know who is going to take what
> patches from this series.

I asked jolsa to pick the lot up since its mostly userspace, if he
remembers he can put it in.

--34/PV/2fFpU6TJrn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdjKiAAoJEHZH4aRLwOS6UPAQAIeVGW3U447IgMRDrv8WexaZ
PF+FHVzW1kxBoo/+xY+Ngvr50L1e2YbEmkGa43F36jrGK1x7nD1OGxYmlaf8dZ39
JHJ/NvpbuGhfNcaMin1mmDBbSse/cmKcyTHEWHEK2IDLY+bhWVm7M3QRPq4g1VH+
8HwV+nqWl6Q43kpx+YNDIZrS4P2WKWPBPjiPEugLC1wGXFOmtxjR4gJh+3eGaPYL
X/PCb9A3oFmu7O6+xAD99H7zEZuWs1HIUefgZD6Agnu5Q6Lq8qj6MLHYqi4gC4hx
siE18fNHlIZ7YoaEGKHfn0yexIhyjr/3tIdxZysTzZjIDijG2VTTRz3pKheeaW08
rFVFo3qdne2P/QcK82FhYaxosXABE3jYrJFn/u6/TdD+2D7KqsIndm0JGnnYm9NM
7lB+EVIfaragL+fUqTZBmywt+5Rn912HCPhtHoYxKCfQIC5aUpnWofkgpZ52SJyS
pT39RVMBCKUN3WzyLY2U8aZ82ba53s7yo0kdkoF676Z5GaUhhnJJpVWV/lic7sdW
HRfrHcHvG2F68mc4xhDgo4QrMCX2KuZh8sBvJRT0r/dAjzDeWUAuDhGZsoUHf1rP
wVOoJkCxhxe1yMUSumW4xUhDHbILLh4vdzP9swmbGCQr6f9pBfQoupRGxOi4+3LU
IT4cPNa7JmXkSuWPLiGg
=n4i2
-----END PGP SIGNATURE-----

--34/PV/2fFpU6TJrn--
