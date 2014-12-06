Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaLFRzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:55:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaLFRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:35 -0500
Date: Sat, 6 Dec 2014 18:55:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        Trivial patch monkey <trivial@kernel.org>
Subject: [PATCH] regulator.txt: fix to fit to 80 columns
Message-ID: <20141206175530.GA26883@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix documentation to fit into 80 columns.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 8607433..a0f9983 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -4,7 +4,8 @@ Optional properties:
 - regulator-name: A string used as a descriptive name for regulator outputs
 - regulator-min-microvolt: smallest voltage consumers may set
 - regulator-max-microvolt: largest voltage consumers may set
-- regulator-microvolt-offset: Offset applied to voltages to compensate for voltage drops
+- regulator-microvolt-offset: Offset applied to voltages to compensate for
+  voltage drops
 - regulator-min-microamp: smallest current consumers may set
 - regulator-max-microamp: largest current consumers may set
 - regulator-always-on: boolean, regulator should never be disabled

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
