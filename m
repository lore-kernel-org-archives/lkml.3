Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbaLKBnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:43:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:34288 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558AbaLKBna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:43:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="651952528"
Date: Thu, 11 Dec 2014 09:43:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alan Tull <atull@opensource.altera.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [socfpga-nex:for_next-fpgamgr-without-overlays-v4.3 8/9]
 drivers/staging/fpga/socfpga.c:655:25: sparse: symbol 'socfpga_fpga_ops' was
 not declared. Should it be static?
Message-ID: <201412110903.GCuPHwdi%fengguang.wu@intel.com>
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

tree:   git://git.rocketboards.org/linux-socfpga-next for_next-fpgamgr-without-overlays-v4.3
head:   7920447fc75922e9a72db640cddf890d75a30e0d
commit: 99aa2d008ce7a2a925368bfddd53ae83d307fb38 [8/9] staging: fpga manager: add driver for socfpga fpga manager
reproduce:
  # apt-get install sparse
  git checkout 99aa2d008ce7a2a925368bfddd53ae83d307fb38
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/staging/fpga/socfpga.c:655:25: sparse: symbol 'socfpga_fpga_ops' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
