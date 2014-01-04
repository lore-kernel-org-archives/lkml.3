Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaADNUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 08:20:21 -0500
Received: from smtp03.stone-is.org ([87.238.162.66]:58559 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaADNUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 08:20:17 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52C80A84.2060707@acm.org>
Date: Sat, 04 Jan 2014 14:20:04 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <greg@kroah.com>
CC: Ming Lei <ming.lei@canonical.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] kobject: Fix source code comment spelling
References: <52C80A50.3000602@acm.org>
In-Reply-To: <52C80A50.3000602@acm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 5b4b888..0061f55 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -346,7 +346,7 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
  *
  * If @parent is set, then the parent of the @kobj will be set to it.
  * If @parent is NULL, then the parent of the @kobj will be set to the
- * kobject associted with the kset assigned to this kobject.  If no kset
+ * kobject associated with the kset assigned to this kobject.  If no kset
  * is assigned to the kobject, then the kobject will be located in the
  * root of the sysfs tree.
  *
-- 
1.8.1.4

