Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaEJGil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaEJGi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:29 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-58-536dc96305e3
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 07/11] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
Date: Sat, 10 May 2014 15:56:34 +0900
Message-id: <1399704998-13321-8-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t8zY93kk7nBBsc2CVosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyvj65yVrwRaWilMXT7I0MF5n7mLk5JAQMJG40P+W
	DcIWk7hwbz2QzcUhJLCMUeLvlONMXYwcYEVd3RUQ8emMEu+7/4A1CAm0MUkcvqkAYrMJ6Eo8
	eT8XbKiIQLbElcb7zCANzAK7GSUaG+eBNQgLuEl0bTjKAmKzCKhKXLvRAWbzCnhI7Jn4gxFi
	mYLEnEk2IGFOAU+Jr18XM0Hs8pB40L0UbKaEwDp2ie3TnrJDzBGQ+Db5EAtEr6zEpgNQj0lK
	HFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFBP3EH4/0D1ocYk4HGTWSW
	Ek3OB0ZNXkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwnnLak5TDr7x/D+davUVtHc/XH8zQOJTqHvG6aOthf373V+sz3ZJWB820uFn26IcE8+4f
	3CIrErt3fy3PncL3/5ooLzvHVvNLBluunq085eSl43xPfcrZgOV1c76uKnF7+tQm+lZSb7nT
	DLt1pfYLy0XX8OxdZKsfutl+St4GiTXdn5IWxFo9UGIpzkg01GIuKk4EAIrP52eQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd3kk7nBBu3reS2WTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAN2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8z4+ucla8EW
	lopTF0+yNDBeZ+5i5OCQEDCR6Oqu6GLkBDLFJC7cW8/WxcjFISQwnVHiffcfNpCEkEAbk8Th
	mwogNpuArsST93OZQWwRgWyJK433mUEamAV2M0o0Ns4DaxAWcJPo2nCUBcRmEVCVuHajA8zm
	FfCQ2DPxByPEYgWJOZNsQMKcAp4SX78uZoLY5SHxoHsp8wRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgmPqmfQOxlUNFocYBTgYlXh4C9/mBAuxJpYVV+YeYpTgYFYS4V1xMDdY
	iDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OB8Z5XEm9obGJmZGlkZmFkYm5OmrCSOO/BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYzL70bNuT1B+ah+vc+r3Ss9Lh/h2jLriEC+z4IU3s0GGeuW
	97zrNb8vNUXtkpSTy4EjVs2eD2a8M/IsUZ0heNns7Kf6qabfZoRaPrgqP/fch0PyBo6PJuj9
	W/Z38Y5D29W1ZtolNXL7R2RNj2KtaytMeBnnpHOypaS5StBbge/NjveHl99ZmvhBiaU4I9FQ
	i7moOBEAbJP3xO0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary header file inclusion from pmu.c.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 05c7ce1..4c3453a 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -11,7 +11,6 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/bug.h>
 
 #include <plat/cpu.h>
 
-- 
1.7.10.4

