Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaFOBUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 21:20:54 -0400
Received: from ozlabs.org ([103.22.144.67]:43239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaFOBUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 21:20:53 -0400
Date: Sun, 15 Jun 2014 11:20:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] MAINTAINERS: power_supply: update maintainership
Message-ID: <20140615112042.4e72c1f8@canb.auug.org.au>
In-Reply-To: <1402759929-15418-1-git-send-email-sre@kernel.org>
References: <1946020.rieJTheGae@vostro.rjw.lan>
	<1402759929-15418-1-git-send-email-sre@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sgXOzKgkFb4S8b/FfGB_1LM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sgXOzKgkFb4S8b/FfGB_1LM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

On Sat, 14 Jun 2014 17:32:09 +0200 Sebastian Reichel <sre@kernel.org> wrote:
>
> Take over maintanence for orphaned power supply subsystem
> and move the git tree to a new kernel.org based repository.
>=20
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> ---
> Hi,
>=20
> As suggested by Rafael in [0] I volunteer to take over the orphaned
> power supply subsystem.
>=20
> [0] http://www.spinics.net/lists/kernel/msg1744793.html
>=20
>  POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
> -M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> -M:	David Woodhouse <dwmw2@infradead.org>
> -T:	git git://git.infradead.org/battery-2.6.git

OK, the master branch of that tree is in linux-next as the "battery"
tree.  My contact for that tree is Anton Vorontsov (cc'd) and its
latest commit is from January.  So should I dump that tree in favour of
the one below with you as the contact?  If so, whatr branch of that
tree should I fetch?  (And should I change its linux-next name?)

> +M:	Sebastian Reichel <sre@kernel.org>
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-sup=
ply.git

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sgXOzKgkFb4S8b/FfGB_1LM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTnPTyAAoJEMDTa8Ir7ZwVLaQP/AmpGO0HW4drkb8NR+kUJWDf
aRp9eEyYxKNz3yBcG6SjJguMex21ClYvgmBSmATf18zvWM/CoNaoJDaIZW6mFZ3x
vp02ULkoSB+Sqn1fKMwcyLVCd1OGnV6j3u2AssqFd1cwbZdiOUEM+4a7YoEIECyw
z2zE5jD3dG3tt6MxKvYcD7qBndwr1vEJ/2vkmEMlGUsK3YF4Q5/m6ZVte1Y4uhoh
abieJYduG5YkWYFc8OAHpic4BKCV1y2k9zp8AX6Dkt5PikIssh47J/gVM6CmRJ90
7V6BMC0Y45kU8dbZRjFVTfksuz5dKb0klDzKeKcNnrVhlmr8zwH2KI8i1/6DeqEU
Q1TPauAZeKpZwacr3Fno2zkTA5jDM3nq9bOIlBGgQATFYdj2L/JdOhmGHhpnDuJ2
xSMiyzQBe/o6bcuYRXAibd/CLIpRWwHiWHMlLq/gPgVsyxERCtGhJhQAG0iA8/o8
1hkSdT7FP4PW1YxvAf0fZKqW4wa3nx80zYAN0132Pz+GUvTnKhFRBbcxs4nAIMaF
zdy7pAlzRlbxQAG3qaMzBzmeUi1b958sRlJ8K1x11zAPxhiLzfMKer7Z6o/70hGZ
Mke2HMhx5w7qFinivLWvLB/ooBNGwAzrjUqKIajNbRIYCBgBQgh7OfjznpECHDFZ
9PgQdVlWu33J3hsutbD/
=chp0
-----END PGP SIGNATURE-----

--Sig_/sgXOzKgkFb4S8b/FfGB_1LM--
