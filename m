Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaLNME4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 07:04:56 -0500
Received: from ozlabs.org ([103.22.144.67]:45482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaLNMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 07:04:54 -0500
Date: Sun, 14 Dec 2014 23:04:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: question about the luto-misc tree
Message-ID: <20141214230445.7caf202b@canb.auug.org.au>
In-Reply-To: <CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
References: <20141214175747.2e6c506e@canb.auug.org.au>
	<CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/I.ib1ux7dZ+tlka/kg4Ny_7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/I.ib1ux7dZ+tlka/kg4Ny_7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Sat, 13 Dec 2014 23:26:36 -0800 Andy Lutomirski <luto@amacapital.net> wr=
ote:
>
> On Dec 13, 2014 10:58 PM, "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
> >
> > The luto-misc tree seems to have a whole series of commits in it that
> > have just bee removed from the rcu tree ...  You really have to be very
> > careful if you base your work on a tree that is regularly rebased.
>=20
> Hmm.  They were there a couple days ago.  Paul, what should I do about
> this?  I only need the one NMI nesting change for the stuff in
> luto/next.

One of them was causing a problem and (I think) the rest were for v3.20
and so Paul reset his tree.

> > I also wonder if the other commits in that tree are destined for
> > v3.19?  If they are for v3.20, then they should not be in linux-next
> > until after v3.19-rc1 has been released.
>=20
> They're for 3.20.  I'll drop the whole series from the next branch for no=
w.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/I.ib1ux7dZ+tlka/kg4Ny_7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjXziAAoJEMDTa8Ir7ZwV3YEP+gMFOxixKMUjw0xFYRQcrTX/
Kgdoqz4pVEHWnR8O/8udAsr3iVi819IrE2ERpr468gy+FwxdHO5NBp/DL+wzFc3m
Ydaw8EOUFUZU1SVPYB4hbFrUR+T4cMF8N1+XygJqwTUmzauNG9upjGyIqciGEimV
gCgpZxlEccaozps73HudvOJViP5aUePmFwU8ySrBy06mxXDuZiL7K8EW6BWJpyFO
9s7d+CVcnD8N+CvGMEao3GM5+pDFNLoP7C9IJ6TSeTXASFPO4NxEcw/7ginHVZIy
j2uQhqS71dBOHqmBxstBTVGQ5z4PwYdW5J1QhZzaK1PWWY0tflpKnMRjSCjGQA0b
onUrA93qQb4OM9VI5fjkyiueRLIVGCh5VXrPu6ROCYuJEaqobP9udJ3+E7DAAYoB
oYhal39fQblSKhecdd1ID0ruJNiJjzz1h8EbEbOfA9yRmEbpP7mzc981pRyi+Xr6
rvjXX2OSO0OYf84WqKTeJgeEP5c3DWK7okLicyU657o0MAbJa/v49YFyPk3ZuuLN
c+9sgGzgbH6YKbLjwEwryNDmw6iIS+5qP6+rHaK8aoj7KEZKUIM+tbtqvx+bEH50
Ix8b2aCR1SW9xvmnQnvYvmAsJ2H+mMtTQztH55EmVLgfZKgTe5Aloez4iVee8uvx
GCdj3B9TeuCGaec7B/p5
=PvpJ
-----END PGP SIGNATURE-----

--Sig_/I.ib1ux7dZ+tlka/kg4Ny_7--
