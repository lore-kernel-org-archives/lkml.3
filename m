Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965989Ab3GSFmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:42:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab3GSF0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 21/72] parisc: document the shadow registers
Date: Thu, 18 Jul 2013 22:25:38 -0700
Message-Id: <20130719052601.314654160@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit a83f58bcb24003b9de2364de7c829a263423ead7 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/parisc/registers |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/parisc/registers
+++ b/Documentation/parisc/registers
@@ -78,6 +78,14 @@ Shadow Registers		used by interruption h
 TOC enable bit			1
 
 =========================================================================
+
+The PA-RISC architecture defines 7 registers as "shadow registers".
+Those are used in RETURN FROM INTERRUPTION AND RESTORE instruction to reduce
+the state save and restore time by eliminating the need for general register
+(GR) saves and restores in interruption handlers.
+Shadow registers are the GRs 1, 8, 9, 16, 17, 24, and 25.
+
+=========================================================================
 Register usage notes, originally from John Marvin, with some additional
 notes from Randolph Chung.
 


