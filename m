Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaGWCjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:39:10 -0400
Received: from ozlabs.org ([103.22.144.67]:45469 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682AbaGWCjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:07 -0400
Date: Wed, 23 Jul 2014 12:38:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20140723123856.3836daae@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/x90joV1SMF=kFFShtkUpD7T"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x90joV1SMF=kFFShtkUpD7T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem_render_state.c between commit
88b982873567 ("drm/i915: fix freeze with blank screen booting highmem")
from the drm-intel-fixes tree and commit 1ce826d436f3 ("drm/i915:
Simplify processing of the golden render context state") from the drm
tree.

I fixed it up (the latter appears to supercede the former, so I used
that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/x90joV1SMF=kFFShtkUpD7T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzyBHAAoJEMDTa8Ir7ZwVqO8P/jsTO3G96YcuPUJjVQgQP/5R
oW8vNr3APilntoEsRHzrmYkJaFK1xisA+pfDnRiuSa7lznNhrPuI6ndle3etTkC5
6lOR9ceZVQ2z4pRsk78EqVfSiYwQkVbvV3DBAdY7WNr9SNGU9e29RHxW0PjnNAzd
3T0frW0lZ2QoU1XFCPqi6V36m/UAUWLYh6zeAxeQOHHZojf9M+dH0DJQmCqDlZML
HtyGyyngXngFn61n09h/keQdjJPQZGMWjZXYY/ATwS+CkhPYiROkVPqQobHCJFka
dGBtZXBXkE2TgUQzwN8tfZqlCNQfTsxSwoj1HRKpdg8zEdHZGZoCiOw82z1/nf0J
mMMBsQOv2f4ZADgAvdxVBqxJZE0hLnugPimRlWQbChiovwxSaZnCE9OtF3fWHIRw
4It/O+DS2yOdPa5q1sm7xwTH2Hhk5yY3n4YO1V/TXk9hgJ5bXp8z+g/ZVtG536T4
Y33KztSQB37I2YqKNvmtYtM5yeR6feQ8P8dRFEf/igKD5orjQyFpTPhjV+bpTS73
0WyQIokJCdiiaJowJ2UYjSRnsvJyJxFQusgIL4Pv321r9ChXzpN2zPf+ZkVfHlU8
Z6h5wCAO8Q6rwRrko6uUQdgUtTe1Ww5/NnbTYa92Czlcr9UOr7gM1DjUwhXE9b52
jUrMnhhT0cuw2Dliack6
=Eo1y
-----END PGP SIGNATURE-----

--Sig_/x90joV1SMF=kFFShtkUpD7T--
