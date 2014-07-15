Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbaGPAKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:10:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845AbaGOXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 36/44] Score: Modify the Makefile of Score, remove -mlong-calls for compiling
Date: Tue, 15 Jul 2014 16:17:34 -0700
Message-Id: <20140715231647.766069926@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231646.690728348@linuxfoundation.org>
References: <20140715231646.690728348@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit df9e4d1c39c472cb44d81ab2ed2db503fc486e3b upstream.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/score/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -20,8 +20,8 @@ cflags-y += -G0 -pipe -mel -mnhwloop -D_
 #
 KBUILD_AFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(cflags-y)
-KBUILD_AFLAGS_MODULE += -mlong-calls
-KBUILD_CFLAGS_MODULE += -mlong-calls
+KBUILD_AFLAGS_MODULE +=
+KBUILD_CFLAGS_MODULE +=
 LDFLAGS += --oformat elf32-littlescore
 LDFLAGS_vmlinux	+= -G0 -static -nostdlib
 


