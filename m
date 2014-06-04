Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaFDQtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:49:22 -0400
Received: from ozlabs.org ([103.22.144.67]:37000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaFDQtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:49:20 -0400
Date: Thu, 5 Jun 2014 02:49:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: linux-next: build warning after merge of the ftrace tree
Message-ID: <20140605024913.4c8cad55@canb.auug.org.au>
In-Reply-To: <20140604122612.366e2874@gandalf.local.home>
References: <20140604160921.4f4e69c4@canb.auug.org.au>
	<20140604122612.366e2874@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7nP0D4XMq1Tf5TdH_jJgh7z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7nP0D4XMq1Tf5TdH_jJgh7z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 4 Jun 2014 12:26:12 -0400 Steven Rostedt <rostedt@goodmis.org> wrot=
e:
>
> On Wed, 4 Jun 2014 16:09:21 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the ftrace tree, today's linux-next build (x86_64 allmodc=
onfig)
> > produced this warning:
> >=20
> > kernel/trace/trace_benchmark.c: In function 'trace_do_benchmark':
> > kernel/trace/trace_benchmark.c:38:6: warning: unused variable 'seedsq' =
[-Wunused-variable]
> >   u64 seedsq;
> >       ^
> >=20
> > Introduced by commit 81dc9f0ef21e ("tracing: Add tracepoint benchmark t=
racepoint").
>=20
> Hmm, I don't know why my tests missed this. I do a allmodconfig looking
> for new warning messages too. Oh, but I do need to add this config to my
> regular testing config :-/
>=20
> I'm surprised Wu's bot didn't report it either.
>=20
> I'm not going to rebase, but I'll add a patch to nuke it.

Correct behaviour!  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7nP0D4XMq1Tf5TdH_jJgh7z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj04OAAoJEMDTa8Ir7ZwVa/oP/jgzbOjJUhP4aUHvIjdqnLyE
ByP+nBngi1/WM+z9lrZeUrunVbYh6oG8CZkHqJ8VlUFXtZeBa41GvsN99iTxolE7
fU90wmMfWB4jQX771P/zV2FbgkehaxVecNFq2n30iKQsXC/Zt3W+CvJmMIPYEbRq
9ne/ineHBGMkF4ESgaA1yIyVlU7m+2nHGsYszOdy0+uiHOLba9PR+Cy1LrRvSRmR
iit4td0ORrHnjUv3xkD5Umfovn/OPtBo84YPMlbnL99DFk7c1SGe4EPrjWg8m4tK
xC5z1SczbB9WF5iRMKt0Gnv+pRnBM8Jdf9LtMI/tGPMkWG4uP4EZYNqmxQb/OUku
ETLjTkr9cCaSW3n19PZmjwOZJmkAvhpWMvboyhPIyKK1xuy2rHxludeJCyMoB+ff
43eyNVdPqtuc5Jf8wWGMXZG0ADjej60klyimFx9WQoWPX754twLRUWej2BE6qslX
j3+Gl2dAg4BNlkpXMk9V0Ht1CK0Pv3dKkNGLN8QkAkx6oOMkkUvP17A+/wqASFI3
AE6tkgsMHLdTiHKBmqRCbrx7tSrVLJTcE626sckt1YFJJsRSKIL+hLmsHVVu7DqN
2jDBNRGXOzpLzAE1eY3dskuoQTuLDtxBVZIEnKiBL+tJ2vS96cv9k+HKIVHRlVDm
yasvfekQZaSAKRu9vpOp
=lRl5
-----END PGP SIGNATURE-----

--Sig_/7nP0D4XMq1Tf5TdH_jJgh7z--
