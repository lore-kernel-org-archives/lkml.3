Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3H1Fyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:54:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10547 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3H1Fyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:54:35 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-29-521d909851e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
In-reply-to: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
Subject: [PATCH 3/5] mfd: tc6387xb: Remove .set_pwr() callback
Date: Wed, 28 Aug 2013 14:54:32 +0900
Message-id: <000b01cea3b3$113e92b0$33bbb810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6gAAEUEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zQ90ZE2SDDNr3Klhsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDK2/F7GUnCVr6LnzRu2BsZzPF2M
	nBwSAiYSqyd+YYawxSQu3FvP1sXIxSEksIxRYtu7D6wwRfM6zkElpjNKLN12gR3C+cUo0bXs
	IhNIFZuAmsSXL4eBEhwcIgJ+Eg0rwGqYBdqZJH7PWMAGUiMkYCtxtreVBcTmFLCTONF+kxGk
	XhjIfrAtGiTMIqAqsefJP7ASXqDyi/0NULagxI/J98BsZgEtifU7jzNB2PISm9e8ZQYZIyGg
	LvHory5IWETASGLe3pvMECUiEvtevGMEOUdCoJFDoqP/BwvELgGJb5MPsUD0ykpsOgANCEmJ
	gytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC4rt3
	B+PtA9aHGJOB1k9klhJNzgemh7ySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MF6fy86kZCpu9PZAktlzxecuhqqZOSffPtzjYL6kwrz2zITL/5UD
	nWXaP1imrmLPc8kTmedWUsv6S/zO7LM1vHeF7t/62R4++6K76ekdgtnbpaYsFFhunGNy5uqN
	X0Gi16PizienizLEhW8SMjxmvbFt0/yT+1f3broeMzsqPuJoZtvUwu9Xk5RYijMSDbWYi4oT
	AZ+5joQFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t9jQd0ZE2SDDC40yFhsf72RzeL9xnlM
	FvuanrNYXF54idViYtMdFov7X48yWlzeNYfN4nQ3qwOHx9/n11k8PnyM85jdMZPV49CVtYwe
	d67tYfOYdzLQo2/LKkaPz5vkAjiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmbPm9jKXgKl9Fz5s3bA2M53i6GDk5JARMJOZ1nGODsMUkLtxbD2RzcQgJTGeUWLrtAjuE
	84tRomvZRSaQKjYBNYkvXw4DJTg4RAT8JBpWgNUwC7QzSfyesQBskpCArcTZ3lYWEJtTwE7i
	RPtNRpB6YSD7wbZokDCLgKrEnif/wEp4gcov9jdA2YISPybfA7OZBbQk1u88zgRhy0tsXvOW
	GWSMhIC6xKO/uiBhEQEjiXl7bzJDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQITh7PpHYwrmywOMQowMGoxMNrsVkmSIg1say4MvcQowQH
	s5IIb8l/oBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnAxNbXkm8obGJmZGlkZmFkYm5OWnC
	SuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwRqreWn/Np867fXOOrn1DrNrEZwn/nx86NfFB
	8n2DijCPo3tfi09+csRQ9MW5oP/z+apOp3tbzI3eIn5ne0TgnEWirGczdq95rdBnpReWprOE
	4XFneI+HdfUsg6dzD2XGppXwf9z+tUyn9+K5qUfvO/5fJWpascqW+bvko72vHq38tFXEf/Ns
	DSWW4oxEQy3mouJEAGKgyARiAwAA
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

drivers/mfd/tc6387xb.c:123:2: error: unknown field 'set_pwr' specified in initializer
drivers/mfd/tc6387xb.c:123:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/mfd/tc6387xb.c:123:2: warning: (near initialization for 'tc6387xb_mmc_data.capabilities' [enabled by default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian.molton@collabora.co.uk>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mfd/tc6387xb.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index acd0f3a..001c1cf 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -78,14 +78,6 @@ static int tc6387xb_resume(struct platform_device *dev)
 
 /*--------------------------------------------------------------------------*/
 
-static void tc6387xb_mmc_pwr(struct platform_device *mmc, int state)
-{
-	struct platform_device *dev = to_platform_device(mmc->dev.parent);
-	struct tc6387xb *tc6387xb = platform_get_drvdata(dev);
-
-	tmio_core_mmc_pwr(tc6387xb->scr + 0x200, 0, state);
-}
-
 static void tc6387xb_mmc_clk_div(struct platform_device *mmc, int state)
 {
 	struct platform_device *dev = to_platform_device(mmc->dev.parent);
@@ -120,7 +112,6 @@ static int tc6387xb_mmc_disable(struct platform_device *mmc)
 
 static struct tmio_mmc_data tc6387xb_mmc_data = {
 	.hclk = 24000000,
-	.set_pwr = tc6387xb_mmc_pwr,
 	.set_clk_div = tc6387xb_mmc_clk_div,
 };
 
-- 
1.7.10.4


