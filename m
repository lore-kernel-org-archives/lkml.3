Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaLZUpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:45:02 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36578 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLZUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:44:46 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 2/2] MAINTAINERS: Update DT website and git repository
Date: Fri, 26 Dec 2014 14:43:56 -0600
Message-Id: <1419626636-7130-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419626636-7130-1-git-send-email-robherring2@gmail.com>
References: <1419626636-7130-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Per Grant, secretlab.ca is defunct and he has no plans to resurect it,
so update the DT website and git tree. devicetree.org needs work, but
is better than "Internal Server Error" that secretlab.ca returns.

Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa9ae27..7c6c4df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6977,8 +6977,8 @@ OPEN FIRMWARE AND FLATTENED DEVICE TREE
 M:	Grant Likely <grant.likely@linaro.org>
 M:	Rob Herring <robh+dt@kernel.org>
 L:	devicetree@vger.kernel.org
-W:	http://fdt.secretlab.ca
-T:	git git://git.secretlab.ca/git/linux-2.6.git
+W:	http://www.devicetree.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux.git
 S:	Maintained
 F:	drivers/of/
 F:	include/linux/of*.h
-- 
2.1.0

