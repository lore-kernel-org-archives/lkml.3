Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbbALSMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:12:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbALSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Doug Anderson <dianders@chromium.org>, Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 097/216] i2c: designware: Fix falling time bindings doc
Date: Mon, 12 Jan 2015 18:03:34 +0000
Message-Id: <1421085933-32536-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Anderson <dianders@chromium.org>

commit 8e2596e81a9dd8f9efcf78476f3990f211e25edb upstream.

In (6468276 i2c: designware: make SCL and SDA falling time
configurable) new device tree properties were added for setting the
falling time of SDA and SCL.  The device tree bindings doc had a typo
in it: it forgot the "-ns" suffix for both properies in the prose of
the bindings.

I assume this is a typo because:
* The source code includes the "-ns"
* The example in the bindings includes the "-ns".

Fix the typo.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Fixes: 6468276b2206 ("i2c: designware: make SCL and SDA falling time configurable")
Acked-by: Romain Baeriswyl <romain.baeriswyl@alitech.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/devicetree/bindings/i2c/i2c-designware.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
index 5199b0c8cf7a..fee26dc3e858 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
@@ -14,10 +14,10 @@ Optional properties :
  - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
    This option is only supported in hardware blocks version 1.11a or newer.
 
- - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
+ - i2c-scl-falling-time-ns : should contain the SCL falling time in nanoseconds.
    This value which is by default 300ns is used to compute the tLOW period.
 
- - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.
+ - i2c-sda-falling-time-ns : should contain the SDA falling time in nanoseconds.
    This value which is by default 300ns is used to compute the tHIGH period.
 
 Example :
-- 
2.1.4

