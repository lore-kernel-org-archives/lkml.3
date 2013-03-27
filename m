Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3C0VFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:05:23 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33692 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3C0VFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:05:22 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Date: Wed, 27 Mar 2013 22:05:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Nishanth Menon <nm@ti.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg> <201303241526.59275@pali> <20130327205606.GN10155@atomide.com>
In-Reply-To: <20130327205606.GN10155@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1649977.71GLfpN5RP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303272205.17182@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1649977.71GLfpN5RP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 27 March 2013 21:56:07 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130324 07:31]:
> > it is possible to upstream errata 430973 workaround for
> > RX-51?
>=20
> I think we should make the SMC handling a generic function for
> ARM.
>=20
> AFAIK just the SMC call numbering is different for various
> implementations. So the handler and passing of the parameters
> seems like it should be generic.
>=20

Not only, look at freemangordon's email:=20
https://lkml.org/lkml/2013/3/1/62

> Regards,
>=20
> Tony

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1649977.71GLfpN5RP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFTXw0ACgkQi/DJPQPkQ1KXFgCdHy8r7dC3By2wA4IRk7wLtXjz
GlAAoLuNpRvh0C7/hgGV+8c7WL5fvYVv
=fch1
-----END PGP SIGNATURE-----

--nextPart1649977.71GLfpN5RP--
