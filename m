Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3B1N7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:59:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab3B1N7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:59:45 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <eduardo.valentin@ti.com>
Subject: [PATCH 1/1] documentation: clk: fix couple of misspelling
Date: Thu, 28 Feb 2013 09:59:07 -0400
Message-ID: <1362059947-3706-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correcting misspelling inside the clk.txt.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/clk.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 1943fae..4274a54 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -174,9 +174,9 @@ int clk_foo_enable(struct clk_hw *hw)
 };
 
 Below is a matrix detailing which clk_ops are mandatory based upon the
-hardware capbilities of that clock.  A cell marked as "y" means
+hardware capabilities of that clock.  A cell marked as "y" means
 mandatory, a cell marked as "n" implies that either including that
-callback is invalid or otherwise uneccesary.  Empty cells are either
+callback is invalid or otherwise unnecessary.  Empty cells are either
 optional or must be evaluated on a case-by-case basis.
 
                            clock hardware characteristics
-- 
1.7.7.1.488.ge8e1c

