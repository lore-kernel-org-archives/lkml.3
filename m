Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbaGXXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:01:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274AbaGXXBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:07 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 01/11] Documentation: devicetree: Adapteva vendor prefix
Date: Fri, 25 Jul 2014 01:00:10 +0200
Message-Id: <1406242820-20140-2-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Olofsson <andreas@adapteva.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New
 
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..a8708c7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -6,6 +6,7 @@ using them to avoid name-space collisions.
 abilis	Abilis Systems
 active-semi	Active-Semi International Inc
 ad	Avionic Design GmbH
+adapteva	Adapteva, Inc.
 adi	Analog Devices, Inc.
 aeroflexgaisler	Aeroflex Gaisler AB
 ak	Asahi Kasei Corp.
-- 
1.9.3

