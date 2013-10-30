Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3J3XSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:18:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36997 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J3XSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:18:03 -0400
Date: Thu, 31 Oct 2013 10:17:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Salter <msalter@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, ccross@android.com
Subject: Re: linux-next build failure
Message-Id: <20131031101750.194748bcf59ab6d91b247257@canb.auug.org.au>
In-Reply-To: <20131030135042.9c40bca11370c2cfef29ff51@linux-foundation.org>
References: <1383146865.11574.3.camel@deneb.redhat.com>
	<20131031073700.f9642ce6c35674a45b3905bc@canb.auug.org.au>
	<20131030135042.9c40bca11370c2cfef29ff51@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Oct_2013_10_17_50_+1100_VMpW83tcllj2v5c0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Oct_2013_10_17_50_+1100_VMpW83tcllj2v5c0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 30 Oct 2013 13:50:42 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 31 Oct 2013 07:37:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > [Jut add Andrew to the cc list]
> >=20
> > On Wed, 30 Oct 2013 11:27:45 -0400 Mark Salter <msalter@redhat.com> wro=
te:
> > >
> > > This patch causes a build failure for no-MMU builds:
> > >=20
> > >   commit 41df2957cb010edfa2f9d394d3617da6beeeb660
> > >   Author: Colin Cross <ccross@android.com>
> > >   Date:   Wed Oct 30 11:45:39 2013 +1100
> > >=20
> > >       mm: add a field to store names for private anonymous memory
> > >    =20
> > > The problem is:
> > >=20
> > >   kernel/built-in.o: In function `sys_prctl':
> > >   (.text+0x19854): undefined reference to `madvise_set_anon_name'
> > >=20
> > > madvise doesn't make sense without an MMU.
> > >=20
> > > --Mark
>=20
> OK, thanks.  I'll drop
>=20
> mm-rearrange-madvise-code-to-allow-for-reuse.patch
> mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
> mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
> mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch
>=20
> for now.  They have other question marks - let's revisit everything
> after 3.13-rc1.

I have removed them from my copy of the mmotm tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_Oct_2013_10_17_50_+1100_VMpW83tcllj2v5c0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScZOiAAoJEMDTa8Ir7ZwVUNgP/3RQ+ChujJ0+I/rB5fyULIbN
50iFTiKRlq7saK2Nsg38E1m3/RVayeDjyS1bwjYUwIls3/vH/qrUwrxR0e0pLTbg
RRsT+Ya9awc/Knqm2GH+tmYuLfpWApFNF9YykJdtu3ulEo6pboZpRybbtYNHfSRv
2idZtYymy4lki+91OjR/aI1Vx0W7KntVpe5+aSVNnYUxT+MMhhewt1jIqH871/kG
vddjEpAalK22Y7B5CkdXUTFIdyRrZ5OdR1r9f+2TeDvwJ+fvD/z+cTJMIpLu9CrH
Da7eEoNPeZJbQO0vsGmx1KehMQyCuZlnDcOKzIIGfbe/Zh9NM2J773u7kvpLzthu
Liv5qb+yNV9gwJsqmOKM6N/i5ROdLnEDR48GA9EKIqxpAJU1pQnCe7sXW98EwE1b
cNT9GbrccAKdmClVFBCO6EpLRVFXG8XJ3Y8DYNDbW41sDtBYbI/KABNuVqLPwMjT
k3z6XzyUpGKNcIg/S1Cqhzo/kb/q/YhHj73G2h+p5TDJg1N8G45DdIgFvRFu2W/h
ZBLOduoC7ikSVKBPIg5rydQqTE+OBRPL2yE256xCKpC52xRnuWNu071Ceug9d+TY
9FcL8l/GEp8UT7w8k/py/HeKMW1v0VJ31IFYVAp4wiK0u/RpWrXmGyH1Q56TmscF
kncqO4eY9zIw+9TABJtv
=e6mw
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Oct_2013_10_17_50_+1100_VMpW83tcllj2v5c0--
