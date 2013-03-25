Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3CYKug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:50:36 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56398 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469Ab3CYKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:50:33 -0400
Message-ID: <1364208628.1390.275.camel@x61.thuisdomein>
Subject: [PATCH] serial: sh-sci: remove obsolete Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 11:50:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 10:50:28.0433 (UTC) FILETIME=[90378410:01CE2946]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for SH7367 and SH7377 got removed in v3.8. Now remove their
last Kconfig macros.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 drivers/tty/serial/sh-sci.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.h b/drivers/tty/serial/sh-sci.h
index 4c22a15..5aca736 100644
--- a/drivers/tty/serial/sh-sci.h
+++ b/drivers/tty/serial/sh-sci.h
@@ -15,8 +15,6 @@
     defined(CONFIG_CPU_SUBTYPE_SH7720) || \
     defined(CONFIG_CPU_SUBTYPE_SH7721) || \
     defined(CONFIG_ARCH_SH73A0) || \
-    defined(CONFIG_ARCH_SH7367) || \
-    defined(CONFIG_ARCH_SH7377) || \
     defined(CONFIG_ARCH_SH7372) || \
     defined(CONFIG_ARCH_R8A7740)
 
-- 
1.7.11.7

