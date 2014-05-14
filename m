Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaENFiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:38:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38923 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaENFiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:38:20 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-9a-537301442778
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] lib: devres: Mark devm_request_and_ioremap() as deprecated
Date: Wed, 14 May 2014 14:38:11 +0900
Message-id: <002301cf6f36$b1d11320$15733960$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9vNrG4SlwBlEgYRbuwz7uYvql8NA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zQ10XxuJgg/3n2C1e/5vOYvHr3RF2
	i+bF69ksLi+8xGox+/5jFovLu+awWfzcNY/Fgd1j56y77B77565h9/j49BaLx5dV15g9+ras
	YvT4vEkugC2KyyYlNSezLLVI3y6BK+PMjtPMBTd4K7Yvm8DYwLiUu4uRg0NCwERif0dIFyMn
	kCkmceHeerYuRi4OIYFljBKLf15ngkiYSOxb84wFIrGIUeLFxM1QVb8ZJWbtX8UGUsUmoCbx
	5cthdhBbRMBUYuP7KYwgRcwCbxkljh+5yAKSEBbwlvh7/QnYWBYBVYlt75rAGngFbCW6Duxg
	hLAFJX5MvgdWzyygJbF+53EmCFteYvOat8wQZ6tLPPqrC7FLT+LIu3lQJSIS+168Y4S4+ha7
	xKE1kRCrBCS+TT7EAtEqK7HpADNEiaTEwRU3WCYwis1CsngWksWzkCyehWTDAkaWVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxghcdm3g/HmAetDjMlA6ycyS4km5wPjOq8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJrEz1Gv4D7nzZ78TSdm
	5p5l7RqJNzpPFTe++Hi78OfSquJZ6xRsF4ruLFSWO3Tx/9n15p959qYaW+wU6bm7x2BZ1qM3
	i4QVZwebMpv/XBL7WbX+QMrXCSf+MX5z8jx2QP6wTkCfoHFx9qE/t/gC5hhNEXI9q3Lx9ctQ
	yb8e+/rWr/7p4XqMyVeJpTgj0VCLuag4EQAxjYSV4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAV0XxuJgg6ntzBav/01nsfj17gi7
	RfPi9WwWlxdeYrWYff8xi8XlXXPYLH7umsfiwO6xc9Zddo/9c9ewe3x8eovF48uqa8wefVtW
	MXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjzI7TzAU3eCu2
	L5vA2MC4lLuLkZNDQsBEYt+aZywQtpjEhXvr2boYuTiEBBYxSryYuBnK+c0oMWv/KjaQKjYB
	NYkvXw6zg9giAqYSG99PYQQpYhZ4yyhx/MhFsFHCAt4Sf68/YQKxWQRUJba9awJr4BWwleg6
	sIMRwhaU+DH5Hlg9s4CWxPqdx5kgbHmJzWveMncxcgCdpC7x6K8uxC49iSPv5kGViEjse/GO
	cQKjwCwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO/GdSOxhX
	NlgcYhTgYFTi4b3hXBQsxJpYVlyZe4hRgoNZSYS3fAtQiDclsbIqtSg/vqg0J7X4EGMy0KMT
	maVEk/OBSSmvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgd
	zlp5M7W8KMsPs2OrzRETFdgqqp32aUpA39PO2TeZW3afjl/vvD3/tthc2yUWNyoe7fr4aCvX
	HMalvLFTFaa9v25QpPXL8tXz1TIqfe9Yp2oeK6reI6K2w//47QuSCuydB098PznnwffXu2VV
	Kw5yta9JdJAqi5/LHNpf9uvMp+e936eqFvxTYinOSDTUYi4qTgQAFGfTSkADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap() was obsoleted by devm_ioremap_resource().
(7509657 "lib: devres: Introduce devm_ioremap_resource()") So,
let's mark it as deprecated in order to stop using it.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
---
 include/linux/device.h |    4 ++--
 lib/devres.c           |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 67f003a..769c86b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -627,8 +627,8 @@ extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
 			  gfp_t gfp);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
-void __iomem *devm_request_and_ioremap(struct device *dev,
-			struct resource *res);
+void __deprecated __iomem *devm_request_and_ioremap(struct device *dev,
+						    struct resource *res);
 
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
diff --git a/lib/devres.c b/lib/devres.c
index 2f16c13..44c7cb2 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -147,6 +147,7 @@ EXPORT_SYMBOL(devm_ioremap_resource);
  * @dev: Generic device to handle the resource for
  * @res: resource to be handled
  *
+ * This is deprecated, please use devm_ioremap_resource() instead.
  * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
  * everything is undone on driver detach. Checks arguments, so you can feed
  * it the result from e.g. platform_get_resource() directly. Returns the
-- 
1.7.10.4


