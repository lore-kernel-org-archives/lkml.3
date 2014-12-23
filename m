Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaLWGe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:34:29 -0500
Received: from ozlabs.org ([103.22.144.67]:56620 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaLWGe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:34:27 -0500
Date: Tue, 23 Dec 2014 17:34:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: missing merge fix for the access_once tree
Message-ID: <20141223173418.59e8556f@canb.auug.org.au>
In-Reply-To: <CA+55aFxjeunxnfc8L1r=GWCBUf5uU=bcnDeu6VygMbsCxVgB0Q@mail.gmail.com>
References: <20141223131749.78087632@canb.auug.org.au>
	<CA+55aFxjeunxnfc8L1r=GWCBUf5uU=bcnDeu6VygMbsCxVgB0Q@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/unRcsFdp62Je3/bBtCjcL9c"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/unRcsFdp62Je3/bBtCjcL9c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 22 Dec 2014 20:12:22 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Dec 22, 2014 at 6:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > I have been carrying this merge fix patch for some time.  It should
> > have gone into the merge of the access_once tree.
>=20
> No, you had a different tree that got merged into linux-next, that
> made it an error to do ACCESS_ONCE() on a structure.
>=20
> The thing I merged didn't actually have that final commit, exactly so
> that things wouldn't break from missing conversions.
>=20
> So that patch isn't wrong, but it also isn't exactly a required fix
> until the next merge window..

True, so "should" was a bit strong.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/unRcsFdp62Je3/bBtCjcL9c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUmQzxAAoJEMDTa8Ir7ZwVS8YP/if0ktfD6Jl89VYQTofkBaj4
8z84+Jp6bKYhzaSmPfkpnlpSkh8wkt/1D/vdQgYYNj3moobeztpwiqP92fZmGaXQ
CzJq5Iwp2tpXL5nGcQPxbJv9+hJ7tknCcFeaGlt6OCshYt1Nu4H/PIMf+9DhEOiS
EPBfKJNkuNPwLlxA2icfNwmV7Ec4Ksi+aAxvpmoR++yogQs4R9WEGV0RxHI7UkpL
++rLHiPe3cS0O/6BM844m43d/E+jBEIKTYDjZY1Fm5ZL5mqOjcfydJC7M3Xzng87
g5WC+IEt2fzEHPkMqRYYgls29AJE2M1gXX+RUDlyVC9NomiDZdz1YXZLdT3EgJ2h
MkWh/p/ShQkUP0IaK+xYhkvuk76zoQmhi6t8U9eTYfSyLpCeHT2GgpokmCF2Q4J8
fQkoAhgYGCY9mNL40WHeNXWKReehmrgjEE8p/FPhL2VbrZYCK2bN7lm/nQ/y8twL
1rEFkIH9e2C4tS3Mg+jo4lHv47KBJMZmfnv3SmfMWGgKW2AeaQghYAT2za8F663a
AG6Eb6E+nUROA3jBuRa55Ypi5dVOJVR+uhS9i0E772QWcHdobaEyKIetRY4n1AFs
MXOcBoi2z9d3nXH7DzUeU8gpdd9IKostQVp/GCbfBE9Tlcc8Gs8Da4PVD9mPQO9e
619ZKTOw7gZIfocUaEwe
=B4n4
-----END PGP SIGNATURE-----

--Sig_/unRcsFdp62Je3/bBtCjcL9c--
