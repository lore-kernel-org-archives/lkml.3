Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3LQNjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:39:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53951 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LQNjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:39:32 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 5/9] mtd: nand: davinci: move bindings under mtd
Date: Tue, 17 Dec 2013 15:37:22 +0200
Message-ID: <1387287442-19839-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1387285155-19182-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move bindings under mtd. Do this in order to make davinci-nand
driver usable by keystone architecture.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Taras Kondratiuk <taras@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../{arm/davinci/nand.txt => mtd/davinci-nand.txt} |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{arm/davinci/nand.txt => mtd/davinci-nand.txt} (100%)

diff --git a/Documentation/devicetree/bindings/arm/davinci/nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
similarity index 100%
rename from Documentation/devicetree/bindings/arm/davinci/nand.txt
rename to Documentation/devicetree/bindings/mtd/davinci-nand.txt
-- 
1.7.9.5

