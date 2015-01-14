Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbbANH1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbANH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Romain Baeriswyl <romain.baeriswyl@alitech.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.18 073/150] i2c: designware: Fix falling time bindings doc
Date: Tue, 13 Jan 2015 23:22:24 -0800
Message-Id: <20150114072059.145662632@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/i2c/i2c-designware.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


