Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaFCWeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:34:23 -0400
Received: from ozlabs.org ([103.22.144.67]:39401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaFCWeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:34:22 -0400
Date: Wed, 4 Jun 2014 08:34:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: linux-next: bad commits in the nfs tree
Message-ID: <20140604083411.4296bcd5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/X0+hyxOyqDe1EHel2wHJ2wg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X0+hyxOyqDe1EHel2wHJ2wg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Trond,

I noticed in the nfs tree this morning 2 commits that have been
cherry-picked from Linus' tree:

cc6d854967ce	Linux 3.15-rc8
2b267bb3a8e5	powerpc: Wire renameat2() syscall

These are part of a branch that you merged from Anna Schumaker.  It
looks like they may have been included when Anna was trying to rebase
the rest of the branch onto v3.15-rc8?

Please fix this up before asking Linus to pull your tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/X0+hyxOyqDe1EHel2wHJ2wg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjk1pAAoJEMDTa8Ir7ZwVTTQP/jOXkpDTKyt7U5wkuEN9cl1f
MpSScV35gfD/b8zvwaZ/dvdlQEzh6vXeiBN+SAmuK87oR06XYojrF+fPuGRdwOQf
xC+FiM0NdwE7MJu+/zSOiK2mdMzpmhTl6mXHymcpn0hYCqq7IfR1phmv0F9fVpfl
qsDow/qaOh8QXcEs69Wwj+JUY6bcNE/zUhd4VvyoA42iGGjRnH4DVLMukisMey/N
+rWFRuB3WCgLG9MHkhr5DcXuw0UmGXdS1/rHe9b4ObUyNMAJXlicwgse+k6rr6il
DZT+jhrDAyGsDPIqec62EITc1798OOf3BUK6Pnl5eGKAR2ZhurQqoO7xxw5jkuGh
ZCg8MgAsQzbgHP9gLDnNuc3QlrslKywUayMJgfBtbFbUOwwF2S3C66F6/H/wolpz
OWdqMRYQyv2wxWFhrqMZCxh8yRijXDqCV8aistkg2njNzE2hUPAGK+EARLbgVnt9
QXuZZRDuh281lYKeJtrkiZxf8YyqEpewyE9x5v9XnIuJdNXh4f8x7tD0rgu2rBN9
YoYs/mKHT+5CEq36iXVGoO3zKztaI3gM/cDLhbm71qowENMnDa10FXGE1vgcM5Bf
LwyOAJ9ezEFNAPieL4HiYExun0u7vhW34kxGjCORQ0AMIplMu6gNwCaz7BijOvC/
WMFrnNfEQ12jp0z0jPF0
=BJzb
-----END PGP SIGNATURE-----

--Sig_/X0+hyxOyqDe1EHel2wHJ2wg--
