Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaCXCBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:01:53 -0400
Received: from ozlabs.org ([203.10.76.45]:48200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaCXCBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:01:49 -0400
Date: Mon, 24 Mar 2014 13:01:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20140324130135.d8788dffbc82ad210c53e258@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Mar_2014_13_01_35_+1100_dPg0EMQC22ND7ohj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Mar_2014_13_01_35_+1100_dPg0EMQC22ND7ohj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got conflicts in
drivers/gpu/drm/i915/intel_ddi.c and
drivers/gpu/drm/i915/intel_dp.c between commit 825938307f81 ("Revert
"drm/i915: don't touch the VDD when disabling the panel"") from Linus'
tree and commits 4be7378004a0 ("drm/i915: drop ironlake_ prefix from edp
panel/backlight functions"), dce56b3c626f ("drm/i915: save some time when
waiting the eDP timings") and b3064154dfd3 ("drm/i915: Don't just say it,
actually force edp vdd") from the drm tree.

This latter commit in the drm tree seems to be solving the same problem
as the one in Linus' tree (but slightly differently), so I just
effectively dropped the patch from Linus' tree and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Mar_2014_13_01_35_+1100_dPg0EMQC22ND7ohj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTL5IIAAoJEMDTa8Ir7ZwVSCQP/j5Dr6gDdjxDn8+gA7K/fZD8
cHMS6mJGIftDbeSxm4hRSfZiG2PE3QbHzsRd8xyp2G+C8/OVDkFpwlOOuS5an6H3
4n8TVf/onZnk5c0jVswFCRGN0u2zywZek8G0LvVlL3eAzzxVIBSzLzM8SBLtKqvY
TnlumiNZLIJLUKkMq5NFQzXRBx8OQgIt2yR3QRf6XRWESqQdlIu2tVOkHZpZuBc7
/p30BDcrThggCGVisYqphVbMel3zWVw1lJswA/LTjDipZ3LJA0yFWCE+MnMiDhbw
hWRxkR2gacltGKYkbeMttk2M9dK3CTdA7LJh5ZcvMPjDEBcmq/rLgTv78fQYdpfA
+8V2Havs8TyUcKfMQkIwhTz7knwrrDoECtkWhA+XbaPoUvltL3Ng/N/10uDrKvNf
4fnNvas0v8JHMbagpdi0Oq2lYDZt67FTLgXGN8LIkb+PC1Ay2SiHU9QlK3juBwqc
5AgWAiOdQuZl2BHRKqu8gRDxkhUP+upnUPk/hCbtfkWfwYSU8Z3BwpaKw4ttstYk
z0NmsHhlgZYt3mFcgaFBS+EOUMKj7dvu0L0tBgptZhYORdL8EO4T8cviE4hhFNul
nTPKHVWturswFouYW046VdtzWYQdWYvYhYuAhZRKxpqjpxpWvySUZ1cyvzzQOn0V
oiRLsKdjcwYjepWjiHWW
=aB/6
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Mar_2014_13_01_35_+1100_dPg0EMQC22ND7ohj--
