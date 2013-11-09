Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab3KIHWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:22:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3KIGva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 3.10 49/74] mm: make generic_access_phys available for modules
Date: Fri,  8 Nov 2013 22:51:54 -0800
Message-Id: <20131109065116.949906385@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 5a73633ef01cd8772defa6a3c34a588376a1df4c upstream.

In the next commit this function will be used in the uio subsystem

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4074,6 +4074,7 @@ int generic_access_phys(struct vm_area_s
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(generic_access_phys);
 #endif
 
 /*


