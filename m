Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab3CRAOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 20:14:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47217 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3CRAOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:14:04 -0400
Date: Mon, 18 Mar 2013 11:13:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-Id: <20130318111357.0eb626f200ce7dfa68d6e81c@canb.auug.org.au>
In-Reply-To: <20130318001102.GC4809@zurbaran>
References: <20130314000201.GA4425@zurbaran>
	<20130315164625.GA29531@zurbaran>
	<20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
	<20130317233907.GB4809@zurbaran>
	<20130318104520.06b6a22c577be324880a4d06@canb.auug.org.au>
	<20130318001102.GC4809@zurbaran>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_11_13_57_+1100_j1YDeUMJqWh8+uSF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_11_13_57_+1100_j1YDeUMJqWh8+uSF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Mon, 18 Mar 2013 01:11:02 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> On Mon, Mar 18, 2013 at 10:45:20AM +1100, Stephen Rothwell wrote:
> > On Mon, 18 Mar 2013 00:39:07 +0100 Samuel Ortiz <sameo@linux.intel.com>=
 wrote:
> > >
> > > > I assume that you are still using the for-next branch?
> > > I will update for-next branch to be in sync with mfd-next until the 3=
.10 merge
> > > window closes. After that I'll probably delete the mfd-2.6.git tree.
> >=20
> > I meant "I assume that I should still fetch the for-next branch
> > of ...sameo/mfd-next.git".  If that has changed, please let me know.
> Sorry for the misunderstanding, I was not clear enough: mfd-next master is
> replacing mfd-2.6 for-next and mfd-fixes master is replacing mfd-2.6 for-=
linus.
> So no need to pull mfd-next for-next.
>=20
> I deleted all branches but master from both mfd-next and mfd-fixes, so th=
ings
> should be clearer now.

OK, I will fix this up for tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Mar_2013_11_13_57_+1100_j1YDeUMJqWh8+uSF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRlxFAAoJEECxmPOUX5FEJDMP/jp3N/jkJjG7IAZs0Fj43p7x
jcphUXv49zX0qiyOomUgmv7cGCsIXpJnvVI3UdmKNItLDoMdFWLvYRRrVA9k0t/9
ZWJmFsNQ+bHgkxsDGN0d7VZoj2ztcZM3UMsFIl4fYmiN9zwTpWkuTIMh1AW+jliS
3Z06+y6WG3lF4gUg0cok0vvyGM9i50RxgME0Nt/OA++lMWyvcae9aIEXnCATHu1V
0NDl91YRAQVqJCTBY9h7VTG9riyTG21VS6wk+3aLqHdSlTQwDE2p/j0yzWw2g1IO
9Khi31iPbts8jiF8VDVER26E0SrMnNUrBPdl17xJGgfx92Rjo/AHMTh6l45cEtlS
96O25c2zH9bVsHUXAfRnUM7ZdxMvF1L0jmZ3V4xxHjQ8kuAhtZbwYDKEVyCcscLj
LPw59j9QSqf1fLcONrjeH+rXde5EItTJwvBMlIDpFKUyGKKgbcRarNsNys6IcE3d
S8eiAZYfFTgIsNMzbrWC5B3jktTFkUPlzxeA18jVWZe79t7boe+2qXGIEREdqVXt
0DNkDizmOVTXq/ByeM0PkMEbTUcl279FwgcOO77YDg6NBw/w0P5Yjc8L2xGU8jRl
NGe1YAWO7arGBmR4gTDoLfKpE79fWcGguddRalBlMOdkcv5lSGHESbYx3Xt4An3C
qupw15v1AVu7F+2MqlJV
=hiBh
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_11_13_57_+1100_j1YDeUMJqWh8+uSF--
