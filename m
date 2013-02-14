Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005Ab3BNRfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:35:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43038 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757938Ab3BNRfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:35:01 -0500
Date: Thu, 14 Feb 2013 17:34:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix memory garbage dev_err printout.
Message-ID: <20130214173456.GU13249@opensource.wolfsonmicro.com>
References: <1360845993-693-1-git-send-email-Russ.Dill@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZ/0/p6gSDXwzas7"
Content-Disposition: inline
In-Reply-To: <1360845993-693-1-git-send-email-Russ.Dill@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aZ/0/p6gSDXwzas7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 04:46:33AM -0800, Russ Dill wrote:
> commit dd8004af: 'regulator: core: Log when a device causes a voltage
> constraint fail', tried to print out some information about the
> check consumer min/max uV fixup, however, it uses a garbage pointer
> left over from list_for_each_entry leading to boot messages in the
> form:

Applied, thanks.

--aZ/0/p6gSDXwzas7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHSA0AAoJELSic+t+oim9vsUP/Rj4a3S89KsOVYXP4DfKqh+W
OIinQcFqTNyLtZeBtIyxsSO3UWLY3yYXrvbOXw+X0iH1vbTnxiLGVQUp/hmy4x4Z
ZTxTPziGwrymXPCMlk1rtzrwozhv3HK1Ca+pSmlVH0ea3fx4wULVBggi/63kpAn7
oZt3djzgxxY+3Fz7amcmPYVYkt9SoyJOXP0nR20WGel4dXPY9TsaqgJxxBPA3CCi
+OVvEEbRdrI7G966K4UO3jOQiq2qBfDeqC4R8Gplv6jzwlyDWVkM0oH6Ce0WqcoN
nOkBzpk5xOUKtaU+RdbQorB0zx2dP82pbXZDe9VQtdX/6V3aRMECOwP8KSRaydXl
nvgdUnCKiVlrk0ZSXdN1L5yrWyz6WmO3xmMr0PiSLpPvp+Yaz2hfQqbk3tjywJVP
WxXTBiN2hzOzeff+LTgNgG/yiUGHH9neDb/PKD0c3MUoEjGGCzkw1cHCutPEKTzU
WensLyT/TaXPaNn6rqwt5gPvEtstR5sRyyinGOt9obqW3wRVJcLm8N83/HK8Iszn
pWzj/gFhCAZ9u9QHvT5m4bTQV1jK/6lyC2Z2SpLJUeJMuwCi++rGOdw5TmjJoPOU
GGnSNpfATPDoaHVK2S0xXaUXDL86A0lphf9h0rn0Cd/1oQpe+metNrZ7Rm0NqGks
sP9qIcw3vCNna+u9p4zK
=9OF0
-----END PGP SIGNATURE-----

--aZ/0/p6gSDXwzas7--
