Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaJOHc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:32:58 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36002
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaJOHc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:32:57 -0400
x-originating-ip: 72.167.245.219
From: Thomas Shao <huishao@microsoft.com>
To: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Cc: Thomas Shao <huishao@microsoft.com>
Subject: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for do_adjtimex()
Date: Wed, 15 Oct 2014 01:39:32 -0700
Message-Id: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export do_adjtimex function for hyper-v Time Synchronization component

Signed-off-by: Thomas Shao <huishao@microsoft.com>
---
 kernel/time/timekeeping.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..205a4b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(do_adjtimex);
 
 #ifdef CONFIG_NTP_PPS
 /**
-- 
1.7.1

