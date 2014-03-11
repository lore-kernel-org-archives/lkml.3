Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaCKKbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:31:34 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:43633 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCKKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Subject: [PATCH trivial 09/16] i2c: Spelling s/than/that/
Date: Tue, 11 Mar 2014 11:23:43 +0100
Message-Id: <1394533430-4746-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org
---
 Documentation/i2c/functionality |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/i2c/functionality b/Documentation/i2c/functionality
index b0ff2ab596ce..4556a3eb87c4 100644
--- a/Documentation/i2c/functionality
+++ b/Documentation/i2c/functionality
@@ -46,7 +46,7 @@ A few combinations of the above flags are also defined for your convenience:
                                   and write_block_data commands
   I2C_FUNC_SMBUS_I2C_BLOCK        Handles the SMBus read_i2c_block_data
                                   and write_i2c_block_data commands
-  I2C_FUNC_SMBUS_EMUL             Handles all SMBus commands than can be
+  I2C_FUNC_SMBUS_EMUL             Handles all SMBus commands that can be
                                   emulated by a real I2C adapter (using
                                   the transparent emulation layer)
 
-- 
1.7.9.5

