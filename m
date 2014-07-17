Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbaGQXDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:03:35 -0400
Received: from ozlabs.org ([103.22.144.67]:55653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbaGQXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:03:33 -0400
Date: Fri, 18 Jul 2014 09:03:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Build allyesconfig for PowerPc tested
Message-ID: <20140718090325.32eb36bb@canb.auug.org.au>
In-Reply-To: <CAPDOMViJfR2qqNRkx_mKpQ0FWd76YN77ev3M=0boZFW6NvS3Pg@mail.gmail.com>
References: <CAPDOMViJfR2qqNRkx_mKpQ0FWd76YN77ev3M=0boZFW6NvS3Pg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Cyk./Nqng5BIvl49ec8t8fU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Cyk./Nqng5BIvl49ec8t8fU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Thu, 17 Jul 2014 14:49:29 -0400 Nick Krause <xerofoify@gmail.com> wrote:
>
> For a while allyesconfig for powerpc seemed to fail building I ran the
> test today to check if
> it builds. It seems to build for me but with warnings. Furthermore
> there seem to be a few
> warnings that need clean up. I can either send another email to the
> maintainers of the powerpc
> architecture branch or you can with my logs as I am attaching them here,

Powerpc allyesconfig will not build completely, this has been known for
a long time.  Even your log shows it failing, so I do not understand
what you are saying.  (BTW, that is not the normal way for the build to
fail, it will always fail when trying to link vmlinux.  Maybe you are
missing some tool to build the kernel signing keys?)

You should report warnings/failures in subsystems to the appropriate
subsyetem maintainer, just because you get these for a particular
architecture does not mean that they are the responsibility of that
architecture maintainer.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Cyk./Nqng5BIvl49ec8t8fU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyFZDAAoJEMDTa8Ir7ZwVDPYP/0CLgml9b3E9KHlLZl+NGonE
BO4iCdUIxzCpAf+siX5pO9QYZwSmPrTz8IfchzXAa7/qFLJcBa+hRPVMD/UFQTXU
SPAXaI4myuq1lzF9iJrU94n6Zy4G4E4kXFIwvtbSvMw6T5ANHJFuuRMjg+vcuMP3
OYJODcdqUt/+P+9zGyfNU5k0I05xtu5qGUdKw5r9UvC7PcF73yGYjcmhyZmIySNg
8Mrd/G9O/FU5Dv2wPtCpjOWw6YTpzEF32x9kO2lC2GUrd9YcaFo9WyekwWLrgndo
wlRt2MgukGWiD/ppay8hgOC4ovuolPqg7KoO6uFhS7uqRcsjQ6QX9Yy7u0ZiiXnS
FUjHXHUd5k6+iM4uTgYe/xMNIBPW5ESR9Spyk3p03+Q/Ux4/+Nux0u781uRGROvr
TS8xSBDm/Zvvh4zPYf6/NLHwYQmhuHVPp/4JfoYLhQqiF45Uue+wpxHej3Sv810z
K+OCUQ5igOjdT71p8a5ZDuOoxakcve4MOetgDwo7kPesKf/vIkRohwVs1xwRjOHd
MFUSowZdNX0KTCepreD7eCF/I/KGQ2GuEO0XAFfxzUr8eL4yXbPt35eUeD1iqBK7
yqTN4Ha+QesFUiPW3VJnIkc4rdJpxwpNXn2Mb9qoAS4OG75HkgZHeWHAnpkra9Z8
zQ5w8db+c4dpqzJIfc0R
=gB2Z
-----END PGP SIGNATURE-----

--Sig_/Cyk./Nqng5BIvl49ec8t8fU--
