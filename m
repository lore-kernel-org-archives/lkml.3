Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaEGIP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:15:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50471 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEGIPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:15:55 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-38-5369ebb5e505
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
Subject: [PATCH 1/4] mfd: tps65910: Make of_device_id array const
Date: Wed, 07 May 2014 17:15:48 +0900
Message-id: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzI23B3Krz2pOTtOM+cSg7C0yRw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zI92trzODDeZekrLo3+JicXnhJVaL
	+1+PMlpc3jWHzeJ0N6sDq8eda3vYPOadDPTo27KK0WPqlL+MHp83yQWwRnHZpKTmZJalFunb
	JXBlTJh+lLlgB2vFq6v72BsYd7N0MXJySAiYSHybc4gJwhaTuHBvPVsXIxeHkMAyRonZqxex
	whSd23uFGSKxiFHiyNN9jCAJIYHfjBJ/74mC2GwCahJfvhxmB7FFgOybe2YxgTQwC0xllNjR
	dgxsnbCAo8TGF0vBbBYBVYmlnZeYQWxeAVuJqVdmM0HYghI/Jt8Dq2EW0JJYv/M4E4QtL7F5
	zVugeg6gi9QlHv3VhdilJ/Gzfx9UuYjEvhfvGEH2SggcYpeY8H4JO8QuAYlvkw+xQPTKSmw6
	wAzxmKTEwRU3WCYwis1CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5
	mxghUde/g/HuAetDjMlA6ycyS4km5wOjNq8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MFZeLXd+ETeryn6eWW5gh//u+Nq4TebtW+169q+47ZKY
	ueVZfJrs0cgtR5e/n198NVHTnn+mquqGoysrdqneYM44tcBlyq8WxbDj3susnijdXBVybO+p
	okv7T68qSmvS4dvnLJQYpf0kJSBiqnfyL6aPVXMNZ358q8Dd91tvp80B4dMTuL5tnKHEUpyR
	aKjFXFScCABHxntP0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd2trzODDfrfi1n0b3GxuLzwEqvF
	/a9HGS0u75rDZnG6m9WB1ePOtT1sHvNOBnr0bVnF6DF1yl9Gj8+b5AJYoxoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAVisplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMyZMP8pcsIO14tXVfewNjLtZuhg5OSQETCTO7b3C
	DGGLSVy4t56ti5GLQ0hgEaPEkaf7GEESQgK/GSX+3hMFsdkE1CS+fDnMDmKLANk398xiAmlg
	FpjKKLGj7RjYVGEBR4mNL5aC2SwCqhJLOy+BbeAVsJWYemU2E4QtKPFj8j2wGmYBLYn1O48z
	QdjyEpvXvAWq5wC6SF3i0V9diF16Ej/790GVi0jse/GOcQKjwCwkk2YhmTQLyaRZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO6WdSOxhXNlgcYhTgYFTi4bV4mxEsxJpYVlyZ
	e4hRgoNZSYR318XMYCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6abvJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgnOj/Tf7Y8xl9Gqk73x7Sm6EQMvdE
	kN6N/Ks7pnQ+jdvRIRR0/yZvyu45WdtvX3yzbcr+D9UPfK9k6GvsmCyf5M/wYO+Cn9HVy3bd
	dl/Kxa6XlFbh92taQvgt62Pmiya8uHTeJkd/ks5+TZZzS2NCZrP+P/nIU1F/3bLk32taD7I9
	e3sn4FSOjpMSS3FGoqEWc1FxIgDQgMcULQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 460a014..f9e42ea 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -379,7 +379,7 @@ err_sleep_init:
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id tps65910_of_match[] = {
+static const struct of_device_id tps65910_of_match[] = {
 	{ .compatible = "ti,tps65910", .data = (void *)TPS65910},
 	{ .compatible = "ti,tps65911", .data = (void *)TPS65911},
 	{ },
-- 
1.7.10.4


