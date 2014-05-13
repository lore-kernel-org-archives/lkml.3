Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbaEMLEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:04:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64298 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760275AbaEMK7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:01 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-5e-5371faf3c962
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Strasser <kevin.strasser@linux.intel.com>
Subject: [PATCH 05/16] mfd: kempld-core: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:42 +0200
Message-id: <1399978733-13662-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xy7qffxUGG/T8MrR4/cLQ4siK7SwW
	978eZbS4vGsOm8XpblYHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGT/b
	HjMXzGateLT5CksD40qWLkZODgkBE4m9+34wQthiEhfurWfrYuTiEBJYyijxacMkKKePSeLG
	gc9gVWwCxhKbly9hA7FFBLIkfkxbDTaJWSBFYvqE+8wgtrCAk8T1jbvB6lkEVCX2zN8IVs8r
	4C6xtHcCO8Q2OYmTxyazgticAh4SL26fBbOFgGpurJrEMoGRdwEjwypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkJD5uoNx6TGrQ4wCHIxKPLwezAXBQqyJZcWVuYcYJTiYlUR43T8VBgvx
	piRWVqUW5ccXleakFh9iZOLglGpg3DT/wfb+2cvnV81bcOxNePHMe2s+SxRcT2icISz72M1u
	F8+ztDtlL0zzXif8qzsdIGVRpvc939V2g/r6zvUsfIJLCuTtGXzePb1QPCWSZ9e0d0s54lVN
	d4duClaLjtrz7r1jQtC9oj4/lvqvl6OenC/xkizz5Tj0Tdfv6x/zXR0HvD/4Lw7xUWIpzkg0
	1GIuKk4EADvegov3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kempld_devs (array of mfd_cells) can be safely made const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>
---
 drivers/mfd/kempld-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index 25c5ca6797da..f7ff0188603d 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -86,7 +86,7 @@ enum kempld_cells {
 	KEMPLD_UART,
 };
 
-static struct mfd_cell kempld_devs[] = {
+static const struct mfd_cell kempld_devs[] = {
 	[KEMPLD_I2C] = {
 		.name = "kempld-i2c",
 	},
-- 
1.9.1

