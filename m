Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3CZHGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:06:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CZHF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:05:59 -0400
X-AuditID: cbfee68e-b7f946d000001e37-87-515148d6130e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce29f0$3eb62f60$bc228e20$%han@samsung.com>
In-reply-to: <001e01ce29f0$3eb62f60$bc228e20$%han@samsung.com>
Subject: [PATCH 3/3] misc: apds990x: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Tue, 26 Mar 2013 16:05:58 +0900
Message-id: <002001ce29f0$5db8b900$192a2b00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4p8D6brC4ZHCKLQ+WHsWIzuH0C8gAABKJA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ91rHoGBBgffaFj8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyJnzey
	FzRzVcyZXdbAuJWji5GTQ0LARKL58hx2CFtM4sK99WwgtpDAMkaJPTOVYGqWt+wCquECii9i
	lGiZ/RPK+cUo0bP9J1g3m4CaxJcvh8FsEQFTiY3vpzCC2MwC6RJ3jnYyQUy1lfj1cDZQnIOD
	U8BO4lNDPEhYWCBM4kxLDyuIzSKgKrG0/S0LiM0LVP792RsoW1Dix+R7LBAjtSTW7zzOBGHL
	S2xe85YZZKSEgLrEo7+6EBcYSVz9u5IdokREYt+Ld4wgJ0sInGKXOLt4N9QuAYlvkw+xQPTK
	Smw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6
	yfm5mxghEdm3g/HmAetDjMlA6ycyS4km5wMjOq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHOYZdek/a6efDP1ifApiTtW4ru2nM3Rmz7d3WDD
	/QLGnal+OxKt+PLbHrRX3318pvG3+aIrih9ZrKIL78Vm1oeZW/p6NHDnvRc7z8G1nMOjNk9q
	/7Ut5RM0o7S0TiivqC89OHeLI5dej9x98X1MnHyvUn4xhM49/vJUqUtivMySGEceA55nSizF
	GYmGWsxFxYkA1wIyC94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd1rHoGBBgt+q1j8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMiZ83shc0c1XMmV3WwLiVo4uRk0NCwERiecsudghbTOLCvfVs
	XYxcHEICixglWmb/ZIdwfjFK9Gz/CVbFJqAm8eXLYTBbRMBUYuP7KYwgNrNAusSdo51MILaQ
	gK3Er4ezgeIcHJwCdhKfGuJBwsICYRJnWnpYQWwWAVWJpe1vWUBsXqDy78/eQNmCEj8m32OB
	GKklsX7ncSYIW15i85q3zCAjJQTUJR791YW4wEji6t+V7BAlIhL7XrxjnMAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/pn0DsZVDRaHGAU4GJV4eDnC
	AgKFWBPLiitzDzFKcDArifD+cQwMFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YDLKK4k3
	NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGWWsFIpwT18xLvzjH
	a3Z4Tm67b9d/X5lEfaUnnkIyB5mncdZxPdK81XnxSmzQNcujAjPWPVc6ylWZbBug4pamsa/7
	wff3J2JYF374JSA4wXyTxqoH6x5mPHHXW782Pvv3TpYNakazTx34k8yrNPdb4NKd0RlWe5eX
	HOEznDQ71SZ2ZlFGde1SJZbijERDLeai4kQApSyeGDwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
when the CONFIG_PM_SLEEP is enabled.

drivers/misc/apds990x.c:1205:12: warning: 'apds990x_suspend' defined but not used [-Wunused-function]
drivers/misc/apds990x.c:1214:12: warning: 'apds990x_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/apds990x.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 1efb6a4..98f9bb2 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1201,7 +1201,7 @@ static int apds990x_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int apds990x_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
@@ -1224,10 +1224,6 @@ static int apds990x_resume(struct device *dev)
 
 	return 0;
 }
-#else
-#define apds990x_suspend  NULL
-#define apds990x_resume	  NULL
-#define apds990x_shutdown NULL
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.2.5


