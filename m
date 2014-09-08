Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaIHIxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:53:45 -0400
Received: from ozlabs.org ([103.22.144.67]:53177 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaIHIxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:53:44 -0400
Date: Mon, 8 Sep 2014 18:53:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hengelein <stefan.hengelein@fau.de>,
        Andreas Ruprecht <rupran@einserver.de>,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the rcu tree
Message-ID: <20140908185336.4e5b6baf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SLUJXmiBe2lhXNJxTHXBVA+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SLUJXmiBe2lhXNJxTHXBVA+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
init/Kconfig between commit d2cf0d24cb2d ("rcu: Fix attempt to avoid
unsolicited offloading of callbacks") from the rcu tree and commit
0c67534a7708 ("init/Kconfig: move RCU_NOCB_CPU dependencies to choice")
from the akpm-current tree.

I fixed it up (a version of the akpm-current tree commit also exists in
the rcu tree, so I used that) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/SLUJXmiBe2lhXNJxTHXBVA+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDW6VAAoJEMDTa8Ir7ZwVuycP/3DCRXxwYqlGHpUGoqr16SDc
8vFjQPEkuAIYAscaUxl2B1r56f8qvJdKtPoSpX62eZZhzyP5Umui7nypHmfWICzZ
yk6chbo3GFa/eD4Pu3zhRWReaeuv44+w38FnBwW2pnLfJRFqJi/PxZctr91qCZWX
RtVlCKsmv2q4lRJhSTtk8taBbsxeXK+sChhk2va0LQhSKGxp40d87uMXekRpKu2w
H6xy/an7OHtLH2Rt6XljR+XqvT0UOxiob01/9AnMtaRLuGmE9dyMBEEtrixessQM
9DjMG4OQtetnmfS7SCA74YCBZ5P2PTzJsI/iAs83yDOnoLJQhZiSIxo/h8snsJB/
fVcV3caUiqQDfWEe9yWxkOk+DkAW+ufj1e+CFN6bVq68PB0mwjXB6ziVgosNjUd6
bZ0S9NPKpRezGJ/92WqX3qxRvwb4iDZypuoM0PzNwHH//mlB/sYHLssmebHPO7Gw
9677EseHHsP/56ose1o3+Rbubpq/7ZnWLf8C29nQDpxYcR3SL6D5S37pqvkSGI2k
aDvboGiHrV4Zp5mpG1Xqvn8hJZqQU1Idh+IVDv0vGQCMwoyUlo2dmOVpVwjyqh+j
ik9Jn8mXpK+vt10s4Uhgp6tqXO9HzfC5eDoremxGlfI9buh8j8uEPmnE02Xuaykv
NTTuSrBM2+YMqlkDKiPr
=6WwN
-----END PGP SIGNATURE-----

--Sig_/SLUJXmiBe2lhXNJxTHXBVA+--
