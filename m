Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaLGQIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 11:08:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54471 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLGQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 11:08:54 -0500
Date: Sun, 7 Dec 2014 17:08:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Trivial patch monkey <trivial@kernel.org>, rjw@rjwysocki.net,
        corbet@lwn.net, geert+renesas@glider.be, broonie@linaro.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/power/regulators/ ... cleanup ranges
Message-ID: <20141207160851.GA18371@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


overview.txt uses '->' to indicate ranges, which is a bit
non-traditional. I changed it to '..' to make it clear.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index 40ca2d6..4dd5dbb 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -90,7 +90,7 @@ Some terms used in this document:-
                    operating parameters and is specified in the regulator
                    datasheet. i.e.
 
-                     - voltage output is in the range 800mV -> 3500mV.
+                     - voltage output is in the range 800mV .. 3500mV.
                      - regulator current output limit is 20mA @ 5V but is
                        10mA @ 10V.
 
@@ -99,8 +99,8 @@ Some terms used in this document:-
                    power domain to a particular power range. i.e.
 
                      - Domain-1 voltage is 3300mV
-                     - Domain-2 voltage is 1400mV -> 1600mV
-                     - Domain-3 current limit is 0mA -> 20mA.
+                     - Domain-2 voltage is 1400mV .. 1600mV
+                     - Domain-3 current limit is 0mA .. 20mA.
 
                    Consumer Level: This is defined by consumer drivers
                    dynamically setting voltage or current limit levels.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
