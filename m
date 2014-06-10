Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFJPNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:13:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:49990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFJPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:13:33 -0400
Date: Tue, 10 Jun 2014 17:13:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Marek Polacek <polacek@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
Message-ID: <20140610151329.GL6758@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
 <20140610145327.GJ6758@twins.programming.kicks-ass.net>
 <20140610150455.GC7335@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WI+ghjzd0JGVd6h/"
Content-Disposition: inline
In-Reply-To: <20140610150455.GC7335@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WI+ghjzd0JGVd6h/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 05:04:55PM +0200, Marek Polacek wrote:
> On Tue, Jun 10, 2014 at 04:53:27PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 10, 2014 at 03:23:36PM +0200, Jiri Kosina wrote:
> > > +# Tell gcc to never replace conditional load with a non-conditional =
one
> > > +KBUILD_CFLAGS	+=3D $(call cc-option,--param allow-store-data-races=
=3D0)
> > > +
> >=20
> > Why do we not want: -fmemory-model=3Dsafe? And should we not at the very
> > least also disable packed-store-data-races?
>=20
> Note that the option does not exist, even though it is mentioned in the
> documentation.

Urgh.. ok. Any word on the packed-store-data thing?

--WI+ghjzd0JGVd6h/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlyCZAAoJEHZH4aRLwOS6COAQAIYdpteaqAxFZhbYzskF5GSQ
tkWrWOm7HUhwWOsH5U41sSwX2kddgadftFfoiE9UZcOT/wmh+0sMJrQUS546vVXx
9QFrKQ+OiIShJ+TNV5Dd4d4LVfIukD/LoBmK74/C4uXCuBAVGOI4mHB9wVMVTeSs
BJ6txPoejlDXMGUguOKSgqH7wMC0QxAAjaddN6hir/5rfsDxKGiWKsWZaVacYs2+
qOpBN+e7qJUiwBe6zcBNminVk8wFjNoMWutGIsZgHGWWkwJXuBB3gcV7+Om+wU/9
w1j509FTc1RKlBe22LmH0OYGMKeLgbvhO2A7PNAdV/SvHvtGG4s/swjtB1qGLS9D
12Mv/Sjedl2TwnbpjNqDgF6F7zUYHvPTNoStGeITxIBXfyZy+HHdPlyq/Gr4DC0R
nOhO3vCthoU5WEJgprc+NhkW48zDNROwyCk2CP3hK4w8hs8VorBvn+4W7I/6WRx4
59QAd4MYL7VaiVdBUUICQthT0s82M4cCAyVRJT+yWD/udnMop8tnZgXotutFZI5I
HGkDIP4TRVMwfvEPyGaqjGg2d/zG3OZQCiOliccuogLtgjQwCxel2JvLV6/1HV3s
VW03FdGrtdb9U3hpTBmpBY/yVa00Byv/SKgUhGQ78+sDTuTyOaVqj4qHUeBpcP3J
d8VCxqIoQduOl+syt2XW
=K8Fg
-----END PGP SIGNATURE-----

--WI+ghjzd0JGVd6h/--
