Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaJMKrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:47:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50200 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaJMKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:47:44 -0400
Date: Mon, 13 Oct 2014 12:47:20 +0200
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Message-ID: <20141013104720.GM27755@sirena.org.uk>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pUZZFPb0jMmCBBeO"
Content-Disposition: inline
In-Reply-To: <1412845377-17134-3-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regmap: cache: cleanup regcache_hw_init().
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pUZZFPb0jMmCBBeO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:53PM +0800, Xiubo Li wrote:
> Remove the redundant code for regmap cache.

Applied, thanks.  With changes like this it is much better if the
changelog explains why the code is redundant - say in words that the
value used is never referenced and looking up the value has no side
effects.

--pUZZFPb0jMmCBBeO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO623AAoJECTWi3JdVIfQKC8H/A3ussDWzIO51ko5KPIOBcvW
v4gLHUK1XTx3CL0QiEm/WDzc+AaQnOK8HiTWlNDkx5KkP2/VR+poU3xLungJr0aZ
67zGKghqLMDOa4yGNmLQ8ErPXVlMEAbcwLVI82CPjzeG/WgdqNKAeEIJFo4u1s/q
sr46sHHpGb9egAOek3ojj1VXEJnLOCzBNz3g9m0/7A0qc9FqGZLcYBJWTNNgO4YL
jbGL4/Vcyj98FCNEk/5bj1S/t8kHXgwe4lWCGm4INMm+FR7ZLcB3oGPY9tWNygwG
3+AWXJDqn0hTN5yb9ulxuGFV9xfeTpAPyRWAGmNbHUI0QBCrqR5wMk4Vf5YRhGk=
=VKP/
-----END PGP SIGNATURE-----

--pUZZFPb0jMmCBBeO--
