Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaHENLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:11:53 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52929 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaHENLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:11:51 -0400
Date: Tue, 5 Aug 2014 10:11:43 -0300
From: Lucas Tanure <tanure@linux.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: [PATCH] drivers: net: ethernet: intel: i40e: Fix missing
 uapi/linux/dcbnl.h include in i40e_fcoe.c
Message-ID: <20140805131143.GA29685@ttmp-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing include in intel i40e driver. Without this include linux next
tree won't compile.

Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 drivers/net/ethernet/intel/i40e/i40e_fcoe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_fcoe.c b/drivers/net/ethernet/intel/i40e/i40e_fcoe.c
index 6938fc1..5d01db1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_fcoe.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_fcoe.c
@@ -33,6 +33,7 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
+#include <uapi/linux/dcbnl.h>
 
 #include "i40e.h"
 #include "i40e_fcoe.h"
-- 
2.0.0

