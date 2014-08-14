Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaHNTa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:30:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:51038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbaHNTa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:30:28 -0400
Date: Thu, 14 Aug 2014 21:30:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        hskinnemoen@gmail.com, tglx@linutronix.de
Subject: Re: [tip:locking/arch] locking,arch,avr32: Fold atomic_ops
Message-ID: <20140814193014.GX6758@twins.programming.kicks-ass.net>
References: <20140531141445.GD16155@laptop.programming.kicks-ass.net>
 <tip-d325209b6000dcd13404ee946d2292e15a56718c@git.kernel.org>
 <20140814192720.GA16175@samfundet.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s0fp+haYq9rM4o+5"
Content-Disposition: inline
In-Reply-To: <20140814192720.GA16175@samfundet.no>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s0fp+haYq9rM4o+5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 09:27:20PM +0200, Hans-Christian Egtvedt wrote:
> Around Thu 14 Aug 2014 10:19:44 -0700 or thereabout, tip-bot for Peter Zi=
jlstra wrote:
> > Commit-ID:  d325209b6000dcd13404ee946d2292e15a56718c
> > Gitweb:     http://git.kernel.org/tip/d325209b6000dcd13404ee946d2292e15=
a56718c
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed, 9 Apr 2014 21:51:29 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu, 14 Aug 2014 12:48:05 +0200
> >=20
> > locking,arch,avr32: Fold atomic_ops
> >=20
> > Many of the atomic op implementations are the same except for one
> > instruction; fold the lot into a few CPP macros and reduce LoC.
> >=20
> > This also prepares for easy addition of new ops.
> >=20
> > Requires the asm_op because of eor.
> >=20
> > AVR32 is a bit special in that its ADD/SUB instructions are not
> > symmetric. Its SUB instruction allows for an 21bit immediate.
>=20
> Fantastic, looks great.
>=20
> Do you have any plans for merge route? I'll happily do it through the avr=
32
> tree, but if it is part of another series, it makes most sense to do it
> there.

I was thinking to keep the lot together in tip/locking/arch.

Once that lands, I'll need to clean up and send pass 3, which
_hopefully_ will be the last, although I had vague plans for a 4th as
well.

--s0fp+haYq9rM4o+5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7Q5AAAoJEHZH4aRLwOS6+X8P/31qbiqW60t6QYRLRpN+0Mkv
WDxPeZV3a89IYJUUjhEEzppiG9kof5hx0+oCI+6Q403hZZH3++tZuCPx/XZog3IW
Hakc4tlYAl3iGCzjUhSiHB+xZp9AYxOrmTMeTNvK4mPNgx46Kh54RzEtB2kEPpf9
gvt+LKB14sgxlKy0+rmFASKJhY7ayYvTMnnteHIBOaN19pxInFTUWcGUAPLjd+u0
3SkYG4maETUGhNFWwuWWSHknhUiSh+sFWz0l2Bka93UDa0tlaQQT1zjVv5CjeXi/
hcks9XlnrNFLdqDnEOJuC0XHegeVpTlntAWTyje20VOUStTX8C6uQSREwEiUopGG
jNRy1P/B3vEQmdy75RvMsc+SDYkE/dI/88I5Es8bU/vtv16QCjc139MdjCrXnTET
ud4TIySc42vu1KvTHnWtvcFLyPcf6mpmJENtaio0oanPEd1FdMZflQnpbTdr3ui8
0wT5zYq40zvLgAun/GCq9+PNb5c6cr39RSavhMcUI4HA/3EgmxtdFuZu4cRJzKn6
wrYBxrwYNuC+rKVMG+JzOH2G5gHIap9uXzcapnwDacs+TBfkG5oDMNelZVpSwUH/
8EpdvvHvHEXgWIgp21eRC77X9t4V4ZvIDX+V5fJ+DGULjViC2YnqaALnGwZxaWyi
FFFIzYJqZy8CBxNqh0q+
=z9et
-----END PGP SIGNATURE-----

--s0fp+haYq9rM4o+5--
