Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab3CRVVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:21:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3CRVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 13/40] tty: serial: fix typo "ARCH_S5P6450"
Date: Mon, 18 Mar 2013 14:10:51 -0700
Message-Id: <20130318211017.215261095@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -458,7 +458,7 @@ config SERIAL_SAMSUNG_UARTS
 	int
 	depends on ARM && PLAT_SAMSUNG
 	default 2 if ARCH_S3C2400
-	default 6 if ARCH_S5P6450
+	default 6 if CPU_S5P6450
 	default 4 if SERIAL_SAMSUNG_UARTS_4
 	default 3
 	help


