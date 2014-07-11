Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaGKEar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:30:47 -0400
Received: from ozlabs.org ([103.22.144.67]:45171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGKEaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:30:46 -0400
Date: Fri, 11 Jul 2014 14:30:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: linux-next: manual merge of the irqchip tree with the arm64 tree
Message-ID: <20140711143039.2a80d8e2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XP+NNr5R3XbbNZ8_bsdUIDH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XP+NNr5R3XbbNZ8_bsdUIDH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the irqchip tree got a conflict in
arch/arm64/Kconfig between commit 875cbf3e4614 ("arm64: Add audit
support") from the arm64 tree and commit 021f653791ad ("irqchip:
gic-v3: Initial support for GICv3") from the irqchip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/Kconfig
index ce6e733e0c05,be52492c2291..000000000000
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@@ -10,7 -9,7 +10,8 @@@ config ARM6
  	select ARM_AMBA
  	select ARM_ARCH_TIMER
  	select ARM_GIC
+ 	select ARM_GIC_V3
 +	select AUDIT_ARCH_COMPAT_GENERIC
  	select BUILDTIME_EXTABLE_SORT
  	select CLONE_BACKWARDS
  	select COMMON_CLK

--Sig_/XP+NNr5R3XbbNZ8_bsdUIDH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTv2hzAAoJEMDTa8Ir7ZwVKPkP/iwXRUpRdE8TcT15FmRppFWk
CiPrdR5v3KAjMkL8vLP64XsLwX2mx/pO9r1lMUmFIn1ipApPp5gPEuwnNN7ceJt9
paNwuVPh+gEGdRmZXfmLxNbpFObcKScfHN45TcQAK23e4yMGe2U+U6BDLC3icJ9c
ySOT7+TnPSk2Wl9PVMv7dY0cg5UmB29endXxjaeLLFa+LwjaxZ29BKhmVR8oMLCP
yODgeCrDDFAI3albpStF5xc3DsxxeA+0L2Veu6f178XYngfjvcuk7+2EGcHI6ZNU
G11EPKXs+2hlrIjmYBhtdk1sQhv/Eo3zKcpsqjJ8o8PkJQAoj6cQci6c+Nth5FPU
giDw/MIGqk8QHyc533v/uuvL+1W4ndcsQ3KpMrdqWgEnf8Hqa5KFnD+/WucToy0y
WeuehL1EpOK0ICfEYU9xS6Qz57ApnQYqOdHv05nHaUmdSb26SKva61McA9gFdn7s
i3fxiWfyb5gp1+5871C0/wYZsuXAPcgqOswi2sSzTUuo3iFVYLOPmlZtSr8Lg8Ow
MJmeKCN9/7zuDU75bZX5BGzvjFo28ov8Ej13jNZt15Ip1LYxsbNvrLfXDpCythTs
H2/c65jXBSCfyC1SF5HfkDj94FTTalMokwG4RSo3ZE5QbPvhd4o80qaXCBf3PbKp
L+GNJ/gAKWoU7q/lCNrI
=HA6Z
-----END PGP SIGNATURE-----

--Sig_/XP+NNr5R3XbbNZ8_bsdUIDH--
