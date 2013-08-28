Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3H1FyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:54:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44076 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3H1FyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:54:06 -0400
X-AuditID: cbfee68e-b7f756d000004512-33-521d907d8395
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>, "'Lee Jones'" <lee.jones@linaro.org>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
In-reply-to: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
Subject: [PATCH 2/5] mfd: t7l66xb: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 14:54:04 +0900
Message-id: <000a01cea3b3$00d3d840$027b88c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6gAADAWA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zQ93aCbJBBrubBS22v97IZvF+4zwm
	i31Nz1ksLi+8xGoxsekOi8X9r0cZLS7vmsNmcbqb1YHD4+/z6yweHz7GeczumMnqcejKWkaP
	O9f2sHnMOxno0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBl91/QKJvFVHPh7j7mBsZ2ni5GT
	Q0LARGLxhiZ2CFtM4sK99WxdjFwcQgLLGCW2z/zABlP09udJRojEdEaJ6dPugXUICfxilDh3
	3hbEZhNQk/jy5TBYXETAT+JA70d2kAZmgXYmiW8n25kgGmwlzva2soDYnAJ2EifabzKC2MJA
	8btXprCC2CwCqhJ/T84Cq+cFiv+bu5MNwhaU+DH5Hlgvs4CWxPqdx5kgbHmJzWveMncxcgBd
	qi7x6K8uxA1GEkf+TmSGKBGR2PfiHdgDEgKNHBKbX79hh9glIPFt8iEWiF5ZiU0HmCEelpQ4
	uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkvvt2
	MN48YH2IMRlo/URmKdHkfGB6yCuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QDY+QKjZmtG1/JeJnVZ6a8V/T+2XMowsZlh1Pukekec79O1rjBWKUg
	6Xiafbnp9/M2WQ8/ODnd4dranmy+e5daXPKBC64Tdl2OLtf+oOr8Ny1GSKXvzteA7e97O869
	CLn9R6tf48q5WG/Jvvv+xlM23VEW60n4dExdPzTm2sI9u5/wnbRj+sJfpsRSnJFoqMVcVJwI
	AMIjus8FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd3aCbJBBtsn8lhsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFm9F3TK5jEV3Hg7z3mBsZ2ni5GTg4JAROJtz9PMkLYYhIX7q1n62Lk4hASmM4oMX3aPXaQ
	hJDAL0aJc+dtQWw2ATWJL18Og8VFBPwkDvR+ZAdpYBZoZ5L4drKdCaLBVuJsbysLiM0pYCdx
	ov0m2AZhoPjdK1NYQWwWAVWJvydngdXzAsX/zd3JBmELSvyYfA+sl1lAS2L9zuNMELa8xOY1
	b5m7GDmALlWXePRXF+IGI4kjfycyQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECE4ez6R2MK5ssDjEKMDBqMTDa7FZJkiINbGsuDL3EKME
	B7OSCG/Jf6AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wMTW15JvKGxiZmRpZGZhZGJuTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MPZ654j8dV78oO2l+avK37zxHBuz4/dZRxz2
	cVC89PX8R/PDQbGrUg8tit7Wq/rSj7dQSnBhw455n47+rjPaNLUw7zvv/76ycyX2RVt3Fjn2
	ZJ5OiQvYdrzvX+bz9Eam1VNOZ5+sWu3m1V27ZaXrbLO31a8KWC/r/xD+v6611LZv6tPjBqUr
	JZRYijMSDbWYi4oTAQxZwOZiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3af9d15 "mmc: tmio-mmc: Remove .set_pwr() callback from
platform data", .set_pwr() callback is removed from platform data.
Thus, .set_pwr() is not used anymore. Also, this patch fixes
the following build error and warning.

drivers/mfd/t7l66xb.c:146:2: error: unknown field 'set_pwr' specified in initializer
drivers/mfd/t7l66xb.c:146:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/mfd/t7l66xb.c:146:2: warning: (near initialization for 't7166xb_mmc_data.capabilities' [enabled by default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian.molton@collabora.co.uk>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mfd/t7l66xb.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 9e04a74..0ddb6a0 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -123,14 +123,6 @@ static int t7l66xb_mmc_disable(struct platform_device *mmc)
 	return 0;
 }
 
-static void t7l66xb_mmc_pwr(struct platform_device *mmc, int state)
-{
-	struct platform_device *dev = to_platform_device(mmc->dev.parent);
-	struct t7l66xb *t7l66xb = platform_get_drvdata(dev);
-
-	tmio_core_mmc_pwr(t7l66xb->scr + 0x200, 0, state);
-}
-
 static void t7l66xb_mmc_clk_div(struct platform_device *mmc, int state)
 {
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
@@ -143,7 +135,6 @@ static void t7l66xb_mmc_clk_div(struct platform_device *mmc, int state)
 
 static struct tmio_mmc_data t7166xb_mmc_data = {
 	.hclk = 24000000,
-	.set_pwr = t7l66xb_mmc_pwr,
 	.set_clk_div = t7l66xb_mmc_clk_div,
 };
 
-- 
1.7.10.4


