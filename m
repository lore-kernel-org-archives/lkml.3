Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaICWQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:16:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbaICWQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.16 033/125] ARM: dts: AM4372: Correct mailbox node data
Date: Wed,  3 Sep 2014 15:06:30 -0700
Message-Id: <20140903220624.653635910@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit 44e6ab1b619853f05bf7250e55a6d82864e340d7 upstream.

The mailbox DT node for AM4372 is enabled and is corrected to
remove some properties that have crept in by mistake.

Fixes: 9e3269b (ARM: dts: AM4372: Add L2, EDMA, mailbox, MMC and SHAM nodes)
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/am4372.dtsi |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -168,9 +168,6 @@
 			ti,hwmods = "mailbox";
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <8>;
-			ti,mbox-names = "wkup_m3";
-			ti,mbox-data = <0 0 0 0>;
-			status = "disabled";
 		};
 
 		timer1: timer@44e31000 {


