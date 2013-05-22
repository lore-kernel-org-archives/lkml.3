Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3EVHU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:20:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58708 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3EVHU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:20:26 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b2-519c71b88118
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: add __cpuinit annotation to write_pen_release()
Date: Wed, 22 May 2013 16:20:24 +0900
Message-id: <000201ce56bc$d399b770$7acd2650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5WvMC/goR1YW5iSp+DM8QRnLJLfg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI90dhXMCDXrPqltcXniJ1aJ3wVU2
	i02Pr7FaXN41h81ixvl9TA6sHpuX1Hv0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxtONixgL
	HnBVzPuk28DYydnFyMkhIWAi8WLKKzYIW0ziwr31QDYXh5DAMkaJ+Rc+McMUnfl2mR0iMZ1R
	YsLZK0wQzi9Gid5DMxlBqtgE1CS+fDnMDmKLCGhIPN19hBGkiFmgl1Hi24SnYAlhAV+JScun
	gDWwCKhK3F/dDLabV8BSYtq3ZhYIW1Dix+R7YDazgJbE+p3HmSBseYnNa95CnaQgsePsa0aI
	ZXoS719BzGEWEJHY9+Id2GIJgU3sEl23ZrJCLBOQ+Db5ENBQDqCErMSmA1BzJCUOrrjBMoFR
	bBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJs/4djHcPWB9i
	TAZaP5FZSjQ5HxineSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg5PYpP2YSuPamZ+ByvW15Cr7M+9Iv/tzGvdbX9NbJll+2u5MaHm1v5zbZf4x1
	8lYOX9nID5qPPrTe82JmfxHwbLZHsdqXUIlbulGa0aGHQn5PffEq8/2bTdL79j2bvHxjUp/m
	Lm7u4GtN29ezsTH2zv8pI3C7YOqd+VfDzQ99ymYyMz7FkrFzrhJLcUaioRZzUXEiAG4UdpvJ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQd0dhXMCDVa0KFtcXniJ1aJ3wVU2
	i02Pr7FaXN41h81ixvl9TA6sHpuX1Hv0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bTjYsYCx5wVcz7pNvA2MnZxcjJISFgInHm22V2CFtM4sK99Wxd
	jFwcQgLTGSUmnL3CBOH8YpToPTSTEaSKTUBN4suXw2AdIgIaEk93H2EEKWIW6GWU+DbhKVhC
	WMBXYtLyKWANLAKqEvdXN7OB2LwClhLTvjWzQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhni
	JAWJHWdfM0Is05N4/wpiDrOAiMS+F+8YJzAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOAofia1g3Flg8UhRgEORiUe3ge1swOFWBPLiitzDzFKcDArifAq
	BM0JFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YILJK4k3NDYxM7I0MrMwMjE3J01YSZz3
	QKt1oJBAemJJanZqakFqEcwWJg5OqQbGBMG+4IMRKl/Yqo5d2zr/sLvBo4AVEk7POrylJmiZ
	ns3z7FSdUTTrXa9tb5CO1Hz+zz/mXW+S1TR/rPWksC9zfaukf6Bq1L9P0ebGn1oNy67cynNO
	eZDE5K/9kaP9+LaJvQpW074tFHhYuERmpWaE/robDpkRr3bz+YSKh7bN2Hz1qxf/m51KLMUZ
	iYZazEXFiQCw6tVbJgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable __cpuinitdata pen_release is referenced by write_pen_release().
Also, write_pen_release() is called by exynos_secondary_init() which is
annotated with __cpuinit. Thus, __cpuinit should be added write_pen_release()
to fix section mismatch warning.

Fixed section mismatch warning as below:

  WARNING: vmlinux.o(.text.unlikely+0x1f4): Section mismatch in reference from the function write_pen_release() to the variable
.cpuinit.data:pen_release
  The function write_pen_release() references the variable __cpuinitdata pen_release.
  This is often because write_pen_release lacks a __cpuinitdata annotation or the annotation of pen_release is wrong.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index a0e8ff7..9676af2 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -58,7 +58,7 @@ static inline void __iomem *cpu_boot_reg(int cpu)
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
  */
-static void write_pen_release(int val)
+static void __cpuinit write_pen_release(int val)
 {
 	pen_release = val;
 	smp_wmb();
-- 
1.7.10.4


