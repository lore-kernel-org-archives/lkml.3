Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3FYIQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:16:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58653 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FYIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:16:32 -0400
Date: Tue, 25 Jun 2013 18:16:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Robin Holt <holt@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the samsung tree
Message-Id: <20130625181621.bae8e93ec1ceedd7b70c7812@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_18_16_21_+1000_PSTr0BAPhTIVDQhg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_18_16_21_+1000_PSTr0BAPhTIVDQhg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm/mach-s3c64xx/common.c between commit cae36a5ce9c9 ("ARM:
SAMSUNG: Set PWM platform data") from the samsung tree and commit
"reboot: arm: change reboot_mode to use enum reboot_mode" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/common.c
index 0b33683,54f4a05..0000000
--- a/arch/arm/mach-s3c64xx/common.c
+++ b/arch/arm/mach-s3c64xx/common.c
@@@ -26,7 -26,7 +26,8 @@@
  #include <linux/irq.h>
  #include <linux/gpio.h>
  #include <linux/irqchip/arm-vic.h>
+ #include <linux/reboot.h>
 +#include <clocksource/samsung_pwm.h>
 =20
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>

--Signature=_Tue__25_Jun_2013_18_16_21_+1000_PSTr0BAPhTIVDQhg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyVHZAAoJEECxmPOUX5FEg7EP/1DXJp7xg+yyMLxvdSem6NoQ
PeZpzjLjIO1ua5XaECbaxFVQ56B4w5oXCaNUhEyVewDVkuiwbDKgIffIPWoLGq6i
LQUJwSDm1oOwEeHh22vbeuLrJX7jvJ5y/Sjt1mn4KdAz/tyRUFRQVXfGT4x9u3sp
Ursp6Hk39MyIvnNXm5tkJ1YsaWaTZ3Zw48qN8LtxKSSAokFpQVduLoskEttq3v9o
UWk8VWpOmOnVL9NEBbTBGeJm9vs5cuI+AbdlikW1S8C9ciDUH22AfhNnc6T8JosH
TpG5oECAsR4IkdRwl/t27/drAUAYd+iAqRWgq0a3BZa6334x8qOXLjDeO695PGNK
8uUFKtP9giOyPUETVXZal5STz+OnUpdiXDv+RGhTDOm+gC3FjaPdnsuC/qc6G61h
YLBOnGggOpl5UuYNkfJm3e4jAv7ZAN9qZmNyHlV5mG2iHaJ6Gi2aZwomSlWUn+gu
Ma5WfuU8EDKU9V2RM3EMuGUuNClscRpXGN8wUnbQfhCydGsv1e1oqSUFmN+kBvpM
weLQKyDdSASsvLCvt43jq601I0ygMfKduqIXsqF+hhrqZMosRAGxASrFmowXujzX
UvxmdTTk7vUqiFd+JeBbdtp+pHBQIMpQUptrYkHr9KFI6uzNt63fQqTdIDZmrVyE
z6PbYN7nnLlnarkou2px
=oH4O
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_18_16_21_+1000_PSTr0BAPhTIVDQhg--
