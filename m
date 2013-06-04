Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab3FDIGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:06:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54771 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab3FDIGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:06:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,798,1363104000"; 
   d="scan'208";a="7455449"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Liu Jinsong <jinsong.liu@intel.com>,
        Jan Beulich <JBeulich@suse.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] acpi/processor: remove bm_rld_set of acpi_processor_flags
Date: Tue, 4 Jun 2013 16:05:27 +0800
Message-Id: <1370333128-11412-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/04 16:04:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/04 16:04:48,
	Serialize complete at 2013/06/04 16:04:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bm_rld_set seems obsolete now

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 include/acpi/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index ea69367..cfec509 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -188,7 +188,6 @@ struct acpi_processor_flags {
 	u8 bm_check:1;
 	u8 has_cst:1;
 	u8 power_setup_done:1;
-	u8 bm_rld_set:1;
 	u8 need_hotplug_init:1;
 };
 
-- 
1.7.2.5

