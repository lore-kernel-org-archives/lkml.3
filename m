Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaKENpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:45:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:41695 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932141AbaKENpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:45:04 -0500
Date: Wed, 5 Nov 2014 14:40:40 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH 3/6] phy: Add driver to support
 individual USB PHYs on sun9i
Message-ID: <20141105134040.GE27686@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-4-git-send-email-wens@csie.org>
 <1415081773.665.1.camel@plaes.org>
 <20141105094543.GC27686@lukather>
 <jwvr3xhu6p3.fsf-monnier+gmane.comp.hardware.netbook.arm.sunxi@gnu.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <jwvr3xhu6p3.fsf-monnier+gmane.comp.hardware.netbook.arm.sunxi@gnu.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

Please keep me in Cc.

On Wed, Nov 05, 2014 at 08:27:41AM -0500, Stefan Monnier wrote:
> > Until some new SoC part of the sun9i family comes up, and it will just
> > add to the confusion.
>=20
> Maybe, but then again maybe not.  It depends whether such a new member
> ever shows up, and whether it has a hardware that's compatible enough
> that the code doesn't need to be changed (seems unlikely).

Yeah, and in all cases, we won't be wrong. While if a new SoCs comes
out which is part of the sun9i (let's say A842), you'll have to select
an option that states that it is for the A80.

The list will be confusing for the user and/or a pain to maintain for
us.

> > Such a person would know that the A80 is part of the sun9i family if
> > it has some knowledge of the Allwinner SocS.  And if they don't, A80 or
> > sun9i or both won't make any kind of difference.
>=20
> Actually, I'm fairly familiar with Allwinner's family of SoCs, but
> I kind of lost track of which Ann corresponds to which sunXi.  If I got
> a board, all the documentation would tell me that it's got an A80 on
> board, but not that it has a sun9i thingy on board.  So there's a good
> chance that a user knows "A80" but not "sun9i".

Good thing we do have a wiki page just for that then.

http://linux-sunxi.org/Allwinner_SoC_Family#Comparison_table

> And last I heard the sunXi designations are a bit unreliable since
> Allwinner renumbered them differently (is the A20 a sun7i or a sun8i).

It might have been both to Allwinner. It's always been sun7i for us.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWijYAAoJEBx+YmzsjxAgkuYP/3nnfRMh3gbpy57Yw766PUeA
cp+lWZu4Zr1OO5nfY5zpUjkQRNsquq+P0AQ9fIpSX13hUmHrBLXnY6E+v54l6akj
KGYWOnSsLCNezCnuZzLP/5gQJtJyDWfZE08fF8pjUhE0t660od7yN8X5uc6GVJ29
j8kbR2wpaPO/JL77acbMYLNT8o6sYChwy0q3ps3UzHVhmEWjLa4/8iga6pYST2Vb
xumQ4XzRtRXm+HMvDmTJw28v8yJNujftDLch7OYFNXpq8omuWUVc/p8lK7zg65fP
hkCKR72KPk7Expupdz0CBu4x81E0Cpl7nAsSoXy0Rj1imoYdp9e9xoK54EBjKGon
b6WUJ0o998f5AprUCFGQCt5zmjPFE/QdVFifieQjQdqNsBnE82aQnE5/kfX9oJTp
pwkLFjUrdKDX6HPgONKIGveavbPgVBB+7EkDcOhpjMnccy30595AjN8TjEsj2TNH
zUXbni/5qsjN/DfQVc5Q2LufJnqCF6RrUPZHUZIqyHbTo7Bx8gOf9X8MM007XONH
DXZHR5q5R7rKpIuEsxB3cjodsqD3ICcGfEfkzPCR3ZaTJGnFNfRDWo37yMY5Z1D2
2SnvkQoyKgtFVv+qfBk1/IR06i5t/CXRL5HG3SuD2Bi1B9L5gD/BAbFGxzpPvtsS
476VhDVRpG+iXWpBt8uC
=JByI
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
