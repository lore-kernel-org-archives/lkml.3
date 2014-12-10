Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaLJCNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:13:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:4730 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbaLJCNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:13:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="635317198"
Date: Wed, 10 Dec 2014 10:12:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alan Tull <atull@opensource.altera.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [socfpga-nex:for_next-fpgamgr-without-overlays-v4 8/9]
 drivers/staging/fpga/fpga-mgr.c:46:5: sparse: symbol
 'fpga_mgr_low_level_state' was not declared. Should it be static?
Message-ID: <201412101021.JoZosGm6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.rocketboards.org/linux-socfpga-next for_next-fpgamgr-without-overlays-v4
head:   590b747bfa6791797c241116453acf50bc4e5dda
commit: 356ae534a603de3aa8b1cfc173a777f59273d32e [8/9] staging: fpga manager: framework core
reproduce:
  # apt-get install sparse
  git checkout 356ae534a603de3aa8b1cfc173a777f59273d32e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/staging/fpga/fpga-mgr.c:46:5: sparse: symbol 'fpga_mgr_low_level_state' was not declared. Should it be static?
>> drivers/staging/fpga/fpga-mgr.c:324:30: sparse: symbol 'fpga_mgr_groups' was not declared. Should it be static?
>> drivers/staging/fpga/fpga-mgr.c:365:25: sparse: symbol 'fpga_mgr_dev_pm_ops' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
