Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaCSEWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:22:23 -0400
Received: from ozlabs.org ([203.10.76.45]:50119 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaCSEWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:22:21 -0400
Date: Wed, 19 Mar 2014 15:22:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the drm tree
Message-Id: <20140319152210.e79924dacd3a613965d104a3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_15_22_10_+1100_TduQU=lLzT/V8/WP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_15_22_10_+1100_TduQU=lLzT/V8/WP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/imx-drm/imx-hdmi.c, drivers/staging/imx-drm/imx-ldb.c,
drivers/staging/imx-drm/imx-tve.c and
drivers/staging/imx-drm/parallel-display.c between commits 69fa5293bf8d
("drm/kms: rip out drm_mode_connector_detach_encoder") and fc1645ac826c
("drm/imx: remove drm_mode_connector_detach_encoder harder") from the drm
tree and commit 1b3f76756633 ("imx-drm: initialise drm components
directly") from the staging tree.

I fixed it up (I used the staging tree version as it was a superset of
the drm tree version) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Mar_2014_15_22_10_+1100_TduQU=lLzT/V8/WP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKRt5AAoJEMDTa8Ir7ZwVpJkP/RdZJ2wd2CJKqYz3RwnVtQ7h
+4yPFX7oJWHpjBepTvZOpiVuhjommLwIdILy1mKhRj7XZZ2YYlAKSkX3msDLQ3Fy
f2Lg0MgLAnXbqYeHiA92+X3wSv0jYC6R++316tmSUuVUaRnqBbNOZvW536+db99s
59oGzMD24V++t5inS5u8Blnb5V/f05o/oMxgcI1OeA7UI0ff4hnPcX+LBvqoo5iz
PwN2aGPYNBLh03gwmUBD7yrch+wKCy4qJhux0GXADEXuAz0laVSx/mw2Vo10jk87
4MjK7A80RxPuFkqKBBteim0cyAP/ljQjJak3T/LuEHkJzZqsjeXs+rPUM1wfEVUN
hrJ9mM9ox/s8dbDDAY0bvD/qhNWSn5GbBz187IO6UPBQ6+EzxpOb7LneuGbfpPL5
7jcCC9Jc2GLtacEaRuGFTV/4M9DJYxbS5LWTGJSRPvva9i4UzDqCxFIGF5dXo1EA
Cuk3t8++9WJDOCWpa8itb6i58VBKVZJ73GyX3Sg3XOEG3VBH20Zm/nZHlG7EKEDy
E8CZnE3bEF/sCiVSt4MYR3VrNz0ZVeU7HcPABPy4E0w2tZp7tF/h+cU9T5Kqrts4
oRuvFS7hiQuFVju6Srpbcas17YINdkiKQXwyR5VPVsg9ZcMZKpg9ZruTrQ3jvA/8
Zsh7kQI+UO1SLj2YuunE
=f1W4
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_15_22_10_+1100_TduQU=lLzT/V8/WP--
