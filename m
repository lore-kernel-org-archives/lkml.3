Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3BWLfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 06:35:16 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47027 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3BWLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 06:35:12 -0500
Date: Sat, 23 Feb 2013 14:34:33 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tools/perf/Makefile: drop _FORTIFY_SOURCE right before
 redefinition
Message-ID: <20130223143433.3721d447@sf>
In-Reply-To: <20130222150814.GD18567@ghostprotocols.net>
References: <1361528274-27126-1-git-send-email-slyich@gmail.com>
	<20130222150814.GD18567@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1=+rjn.urz3qqQTLzv5xgzl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1=+rjn.urz3qqQTLzv5xgzl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Feb 2013 12:08:14 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Fri, Feb 22, 2013 at 01:17:54PM +0300, Sergei Trofimovich escreveu:
> > From: Sergei Trofimovich <slyfox@gentoo.org>
> >=20
> > Gentoo's toolchain sets _FORTIFY_SOURCE by default
> > which leads to very obscure error:
> >=20
> > perf # make clean && make
> > Makefile:455: No libdw.h found or old libdw.h found or elfutils is olde=
r than 0.138, disables dwarf support. Please install new elfutils-devel/lib=
dw-dev
> > Makefile:470: *** No gnu/libc-version.h found, please install glibc-dev=
[el]/glibc-static.  Stop
> >=20
> > Patch explicitely undefines _FORTIFY_SOURCE. Thanks!
>=20
> There was a fix merged recently related to this define, can you please
> check?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
>=20
> branch
>=20
> perf/core
>=20
> This patch:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/acme/linux.git;a=3Dcommitdiff=
;h=3D1807606ac70da5cda870362c13e71d60e94f9c13
>=20
> - Arnaldo

Yeah, works fine as well. Thank you!

--=20

  Sergei

--Sig_/1=+rjn.urz3qqQTLzv5xgzl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEoqUsACgkQcaHudmEf86poQgCeL5fhq9aCuOuwbm4A00qb2zBG
M34An2XN5lW0J0NihTUwvQRunwINlRD1
=EubQ
-----END PGP SIGNATURE-----

--Sig_/1=+rjn.urz3qqQTLzv5xgzl--
