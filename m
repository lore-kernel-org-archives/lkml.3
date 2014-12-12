Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789AbaLLQ6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:58:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54670 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933893AbaLLQ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:58:12 -0500
Message-ID: <1418403484.3599.86.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 042/164] vfs: fix data corruption when blocksize <
 pagesize for mmaped data
From: Ben Hutchings <ben@decadent.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 12 Dec 2014 16:58:04 +0000
In-Reply-To: <20141212084815.GA4813@quack.suse.cz>
References: <lsq.1418364865.554543691@decadent.org.uk>
	 <lsq.1418364865.368665223@decadent.org.uk>
	 <20141212084815.GA4813@quack.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ZRL5gopXSOpt2K8Pn87o"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZRL5gopXSOpt2K8Pn87o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-12-12 at 09:48 +0100, Jan Kara wrote:
> On Fri 12-12-14 06:14:25, Ben Hutchings wrote:
> > 3.2.65-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Jan Kara <jack@suse.cz>
> >=20
> > commit 90a8020278c1598fafd071736a0846b38510309c upstream.
>   This patch needs also commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb,
> otherwise XFS will spew lots of false warnings...
[...]

Thanks, I've added that.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-ZRL5gopXSOpt2K8Pn87o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIsenOe/yOyVhhEJAQp/mw//cynmbHxpCZZJTc4oy+VOYXmqgQSEOhaP
bWxzwFh8CvxeQEZs1e+cxyKnnjyHs4hgfEQuHRj63fCZXRRfC6eDAM1P/z+Fp6fp
+2d9jD1siaMD4si1HPHaz5rYe28h1hA4qtTZ7Wv4hTACd6hJdvlZyZXrKSrGZ49T
CUBbJj9QHnGyEyLGJ/my+NSjwe++ZLytYMDSHlhkmx6ETmRxQWYlP7GK3Z/Mc59E
BPr/GxaWMyVSEL9RG5uI1N4Le6adN5KRGFndKyZWxeHGUB0vPTNVaAQJ/I+lcg7s
3ot2TZeWY9Yg5g1Gb8/7yoAC2BNqCuu/UbJUIccLukHq2Arp1C0pvQVgbsHBV8AR
GIG+/94fVirLc7gOTq6DsXy2AKUJGjTiERrRQ9cStx3WLRiiCpNYKth8fie3Fp6M
OObjVGYIqu63syAkDlb7bKObuVqESNKDy7W83lW6RbgxDp2Cq4M0yyAjFkKk0KwE
YdFIGKNnOuC8VijGvZAFSIb/P3uQ2MecwXTtkGWT1fDuB+vWTdP9uXvflzwj6Rjs
cSS4JaD+8oB2sCtQFRw706PAkhFhD3qCpMh2izAvfBV2+l9t/AiI0rn8GSW6nrBT
divZ22FBtETFzyVaMurim6GaOqzVBMtiwgpg/nkSyUSQ5EPd1R3yiPRDhtJJjMNs
UrLi9QTB2qA=
=j0DO
-----END PGP SIGNATURE-----

--=-ZRL5gopXSOpt2K8Pn87o--
