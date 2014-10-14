Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaJNKdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:33:38 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53345
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbaJNKdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:33:36 -0400
x-originating-ip: 72.167.245.219
From: Thomas Shao <huishao@microsoft.com>
To: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Cc: Thomas Shao <huishao@microsoft.com>
Subject: [PATCH 1/2] timekeeping: add EXPORT_SYMBOL_GPL for do_adjtimex()
Date: Tue, 14 Oct 2014 04:10:19 -0700
Message-Id: <1413285019-6987-1-git-send-email-huishao@microsoft.com>
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

