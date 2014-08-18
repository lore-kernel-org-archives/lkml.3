Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaHRV7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:59:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50071 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHRV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:59:31 -0400
Date: Mon, 18 Aug 2014 23:59:28 +0200
From: Pavel Machek <pavel@denx.de>
To: robh+dt@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        pawel.moll@arm.com, mark.rutland@arm.com, dinguyen@altera.com,
        devicetree@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] stmmac.txt: fix typo
Message-ID: <20140818215928.GA4400@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in devicetree example.
    
Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/Documentation/devicetree/bindings/net/stmmac.txt b/Documentation/devicetree/bindings/net/stmmac.txt
index f319112..4012b5c 100644
--- a/Documentation/devicetree/bindings/net/stmmac.txt
+++ b/Documentation/devicetree/bindings/net/stmmac.txt
@@ -49,5 +49,5 @@ Examples:
 		max-frame-size = <3800>;
 		phy-mode = "gmii";
 		clocks = <&clock>;
-		clock-names = "stmmaceth">;
+		clock-names = "stmmaceth";
 	};

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
