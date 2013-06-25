Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3FYTK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:10:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3FYSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Helge Deller <deller@gmx.de>
Subject: [ 23/95] parisc: rename "CONFIG_PA7100" to "CONFIG_PA7000"
Date: Tue, 25 Jun 2013 11:32:10 -0700
Message-Id: <20130625182156.260633202@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 766039022a480ede847659daaa78772bdcc598ae upstream.

There's a Makefile line setting cflags for CONFIG_PA7100. But that
Kconfig macro doesn't exist. There is a Kconfig symbol PA7000, which
covers both PA7000 and PA7100 processors. So let's use the corresponding
Kconfig macro.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -66,7 +66,7 @@ KBUILD_CFLAGS_KERNEL += -mlong-calls
 endif
 
 # select which processor to optimise for
-cflags-$(CONFIG_PA7100)		+= -march=1.1 -mschedule=7100
+cflags-$(CONFIG_PA7000)		+= -march=1.1 -mschedule=7100
 cflags-$(CONFIG_PA7200)		+= -march=1.1 -mschedule=7200
 cflags-$(CONFIG_PA7100LC)	+= -march=1.1 -mschedule=7100LC
 cflags-$(CONFIG_PA7300LC)	+= -march=1.1 -mschedule=7300


