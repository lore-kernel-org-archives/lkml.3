Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbbADXtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:49:06 -0500
Received: from ozlabs.org ([103.22.144.67]:58258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbbADXtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:49:04 -0500
Date: Mon, 5 Jan 2015 10:48:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: bad commit in the luto-misc tree
Message-ID: <20150105104857.1abcec86@canb.auug.org.au>
In-Reply-To: <CALCETrU47KbYVJ0XA4HnA+A4=Zck49ubuutT+SZNDUw+PBxQVw@mail.gmail.com>
References: <20150105103547.40ef87fd@canb.auug.org.au>
	<CALCETrU47KbYVJ0XA4HnA+A4=Zck49ubuutT+SZNDUw+PBxQVw@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/x3C0i=.haa4S7_F2LndULqA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x3C0i=.haa4S7_F2LndULqA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Sun, 4 Jan 2015 15:42:31 -0800 Andy Lutomirski <luto@amacapital.net> wro=
te:
>
> Sorry.  I totally failed here.  I swear I rebased onto the latest RCU
> tree, double-checked it, and pushed that exact revision to luto/next.
> Somehow I pushed a much older development commit.  I have no idea how
> I did that.  I didn't even know I still had that commit around at all.

OK, I have refetched your tree for today and it looks fine.

> Fixed now, I think.  Next time I will push to luto/next and
> double-check that I pushed the commit I thought I pushed.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/x3C0i=.haa4S7_F2LndULqA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUqdFuAAoJEMDTa8Ir7ZwVB5sP/R0oVrkvYictE+g3Tz8YB4MV
yk2NyQlcT6aKefVB7PQhmEPfZkB77LOb4IKYDH1HFvoRu0+deeLFcyA9QKbT9evh
lBqRQsb7J3K5l6nIofhvPicB3fB+bEvHaiLe3Zje2u1mRwedTABgH4+gLoolcr+k
Mp1E6ceODbbPHC/x3jSVNbbDFobfA/y3wVrOiIdeKeygeVW8uNFVPaTtvgfKR4oL
iync4s6EXmbUvTNePyM9Pc/m82wPLvvMWT4qlMVcXVhaBKCDnr4baK+JB+cYyTF2
EZVziZf7mUVOcKAP5EO6QXdj75F6AJxA5jQHPqzAzNcp6ncd5fWsYDV44opNCBUL
p1sSklNYRKOTSwh023dOLy444cVhkm7ZFVTBSXynUJaw9iyXwaXI1lPaWCMG+of0
OuLGsqpp/5D0NJnO+AWUQu5PZu2vBt06J1o7wAgwLqxT43DMR9CkUfCLkyadCtn2
x4uwkmO9dmLtsZ9CoCAn79GitmcWgnFxFUgnkftdVe1v78Vuxx80PyO7Cmr5EEna
/+nOWZxQRYOL+UB8qz5RXPROm295RoBF1Nbgs+QcaKdy42MisOS55FkbVHhjpB2I
fh4hfl0y1z1kLEmUhO7jhiI8M6N0qa13Ww2fhG+/eL8MibiVBOw6CjWJeCi7ZjIk
+REMFvETWWCS+vJbLmGc
=NjDF
-----END PGP SIGNATURE-----

--Sig_/x3C0i=.haa4S7_F2LndULqA--
