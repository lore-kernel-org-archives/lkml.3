Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbaLKBnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:43:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:59090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaLKBna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:43:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="621932367"
Date: Thu, 11 Dec 2014 09:43:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alan Tull <atull@opensource.altera.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH socfpga-nex] staging: fpga manager: socfpga_fpga_ops can be
 static
Message-ID: <20141211014324.GA73956@lkp-sb04>
References: <201412110903.GCuPHwdi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412110903.GCuPHwdi%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/fpga/socfpga.c:655:25: sparse: symbol 'socfpga_fpga_ops' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 socfpga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fpga/socfpga.c b/drivers/staging/fpga/socfpga.c
index 4440b84..ae9a2f1 100644
--- a/drivers/staging/fpga/socfpga.c
+++ b/drivers/staging/fpga/socfpga.c
@@ -652,7 +652,7 @@ static int socfpga_fpga_resume(struct fpga_manager *mgr)
 	return ret;
 }
 
-struct fpga_manager_ops socfpga_fpga_ops = {
+static struct fpga_manager_ops socfpga_fpga_ops = {
 	.reset = socfpga_fpga_reset,
 	.state = socfpga_fpga_ops_state,
 	.write_init = socfpga_fpga_ops_configure_init,
