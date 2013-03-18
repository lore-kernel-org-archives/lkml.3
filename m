Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3CREbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33559 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883Ab3CREah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:37 -0400
Message-Id: <20130318042150.132212188@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Paul Bolle <pebolle@tiscali.nl>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 61/82] tty: serial: fix typo "ARCH_S5P6450"
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 827aa0d36d486f359808c8fb931cf7a71011a09d upstream.

This could have been either ARCH_S5P64X0 or CPU_S5P6450. Looking at
commit 2555e663b367b8d555e76023f4de3f6338c28d6c ("ARM: S5P64X0: Add UART
serial support for S5P6450") - which added this typo - makes clear this
should be CPU_S5P6450.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -464,7 +464,7 @@ config SERIAL_SAMSUNG_UARTS_4
 config SERIAL_SAMSUNG_UARTS
 	int
 	depends on ARM && PLAT_SAMSUNG
-	default 6 if ARCH_S5P6450
+	default 6 if CPU_S5P6450
 	default 4 if SERIAL_SAMSUNG_UARTS_4
 	default 3
 	help


