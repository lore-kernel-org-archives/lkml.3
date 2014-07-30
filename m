Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaG3CE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:04:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaG3Bto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [PATCH 3.14 18/29] parisc: Remove SA_RESTORER define
Date: Tue, 29 Jul 2014 18:48:53 -0700
Message-Id: <20140730014810.097079574@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 20dbea494543aefaace874cc3ec93a39b94b1ec4 upstream.

The sa_restorer field in struct sigaction is obsolete and no longer in
the parisc implementation.  However, the core code assumes the field is
present if SA_RESTORER is defined. So, the define needs to be removed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/uapi/asm/signal.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/parisc/include/uapi/asm/signal.h
+++ b/arch/parisc/include/uapi/asm/signal.h
@@ -69,8 +69,6 @@
 #define SA_NOMASK	SA_NODEFER
 #define SA_ONESHOT	SA_RESETHAND
 
-#define SA_RESTORER	0x04000000 /* obsolete -- ignored */
-
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 


