Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaEPMW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:22:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaEPMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:22:26 -0400
Date: Fri, 16 May 2014 14:22:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, namhyung@gmail.com, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/6] events, perf: Pass protection and flags bits through
 mmap2 interface
Message-ID: <20140516122219.GQ11096@twins.programming.kicks-ass.net>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RuPiyELjUd36Oro"
Content-Disposition: inline
In-Reply-To: <1399999697-65875-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1RuPiyELjUd36Oro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 12:48:12PM -0400, Don Zickus wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>=20
> The mmap2 interface was missing the protection and flags bits needed to
> accurately determine if a mmap memory area was shared or private and
> if it was readable or not.
>=20
> [tweaked patch to compile and wrote changelog]
> Signed-off-by: Don Zickus <dzickus@redhat.com>
>=20
> --
> Peter you mentioned writing up a changelog for this patch, but you
> seemed busy, so I jumped the gun a little bit.  Let me know how you
> want to do this patch if this approach is wrong.

Oh, right, totally forgot about that. yeah I think the blub you have is
adequate.=20

--1RuPiyELjUd36Oro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdgL7AAoJEHZH4aRLwOS6HGwQALWXMWj72ChUOpqdWD7Y9dgj
UaGZs1+rc7bfX7oxvOIeCDJ+0sM9IRMgA3FGUJEfGHS1N14uAl1U6zL6RQpfEn5m
GEzg1UQhDZP/mJ4nFXnZgHo5zXi9A8q9/3WMUc7LDGDkywFIWBPUFDdVAFngtrLl
LG5yI8v+wxsAbghZInDH6ftjQ2LtKc/M3S58VPrDYhLv4+I5cVi5nle2ixcf7Bre
QcvIRqC72gPppglABzaZAfgIRX3ldeoyOznbNOI5/fgjEoBZsKwbHJWX465BYqda
i7jSYo2AMrvUGJAaD8ET6zDaTrPFIzINvJejJ95C4sJ+sS9oyrF/+/jgwqGQAe7V
OVeHJMIlrZVoN/yIytMGS5QPu1baO9xN8FWzEdo1Jn7if4yvRidGMYfdj5yizdsu
oKGlfyrY4ZfcD3kQ4SsTuARll+ouCf1OkqNXxnCL1TH04hMf7qesjDcP9xBDQLKH
Kuo3nuXLhKfcpTRf2izxjdFX2lUBWjwIH4H/gVqCi43ELiaYXTT3A63qg3yT1VRl
BtD6IO2zxsiSAO7IyUW1AkbPBGmM7EKn9R9csYD2cCcQ+RZ/Q9yiQIysxWRLJlDq
6fo6qm67QmGCXyZRSXG6Vip8aDyv2DAW6P6TaUUtxSgECefSn4dSdnpeNSGaGHSx
P8Ax/oituYRSAABl2Ifu
=qsmL
-----END PGP SIGNATURE-----

--1RuPiyELjUd36Oro--
