Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3CYKNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:13:15 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60694 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580Ab3CYKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:13:12 -0400
Message-ID: <1364206387.1390.266.camel@x61.thuisdomein>
Subject: [PATCH] staging: sb105x: Remove obsolete CONFIG_M386
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 11:13:07 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 10:13:08.0223 (UTC) FILETIME=[58F298F0:01CE2941]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/staging/sb105x/sb_pci_mp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.h b/drivers/staging/sb105x/sb_pci_mp.h
index f33efde..a15f470 100644
--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -174,7 +174,7 @@ static DEFINE_MUTEX(mp_mutex);
 #define DEBUG_INTR(fmt...)  do { } while (0)
 #endif
 
-#if defined(__i386__) && (defined(CONFIG_M386) || defined(CONFIG_M486))
+#if defined(__i386__) && defined(CONFIG_M486)
 #define SERIAL_INLINE
 #endif
 #ifdef SERIAL_INLINE
-- 
1.7.11.7

