Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbbAICHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:07:01 -0500
Received: from ozlabs.org ([103.22.144.67]:33353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbbAICG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:06:59 -0500
Date: Fri, 9 Jan 2015 13:06:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Rob Clark <robdclark@gmail.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-ID: <20150109130650.4f7a7a29@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/arOovnPoy53f0mfGef.8aBA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/arOovnPoy53f0mfGef.8aBA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_runtime_pm.c between commit 7f1241ed1a06
("drm/i915: Kill check_power_well() calls") from the drm-intel-fixes
tree and commit e2c719b75c8c ("drm/i915: tame the chattermouth (v2)")
from the drm-intel tree.

I fixed it up (the former removed the code modified by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/arOovnPoy53f0mfGef.8aBA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrze+AAoJEMDTa8Ir7ZwVPLgP/j0zZchZKy3gxk1erwvpuMM9
vNCGFjymWlAQE2dc3rwosNIp4hqSLEdbVI7/XbZO4cbwpafHGQNXCj20CUj0ICnp
AAD49MV1Cf/vWrm2cGeSBEb8Ud/yuRxqD2vF+o1XHc02PzEvYKwbgrwZjyKWEY7m
W5o8M5byZ6fjhfIFf6Uy5laWKGAohftkrRT7FnZCx8zPKK5yKZlx3kV5DiyYg/f1
6NqJrrjqyjvieoUXm4FzXydc6LhUUxKCLr4HHg3NIHTb/xYv8C4pDSdO2IIO5WLR
34E264Hv+pOpio+Uj98Z9svpSyndyim+lDb+8yJzAsYGwoYAJUEVZegrY8eyUE95
+3GliTYsMuMB3f4UwkEUqe8Ma1Mqe09GU+wFcBtpECEV1Bssjt1F0XNR3HHAX7jT
XaLxT8ablu1u1LezCWUBuu4/uv7qOokbzhPwE2iJJcaNqsuyAFIOboplXgFXF8hy
1JM+6cCXX9dTZUwT+VtRG+Ou0m1YfhoXP3YqUe/P2V1D6RC4hkElth2Nia9Q0uV8
TGHCmnXCsAoAOQyBmLAvvkcCdSiW7BUhRU+eQWymOb0AZyDjVhIuYFly/nv2HXo/
cfkOstxA2HeMVvmaoVEU3y+sv//MEJdAAjCiw+iwLFZf1WeKjL1pLDp47ffAQ1t8
CKT1zk/eSn4c9kH4rPo3
=508J
-----END PGP SIGNATURE-----

--Sig_/arOovnPoy53f0mfGef.8aBA--
