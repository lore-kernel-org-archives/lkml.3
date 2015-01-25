Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbbAYRSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:18:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:58527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbbAYRSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:18:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,463,1418112000"; 
   d="scan'208";a="675688587"
Date: Mon, 26 Jan 2015 01:17:54 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: kbuild-all@01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [char-misc:char-misc-testing 54/73] drivers/hv/vmbus_drv.c:582:6:
 sparse: symbol 'hv_process_timer_expiration' was not declared. Should it be
 static?
Message-ID: <201501260143.KqbhD5l0%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git char-misc-testing
head:   930c796ad9a62bdc8384cbb71d5af332d9ec92f7
commit: 71123d54fb2346c7652d8d05dac2cee28cd69954 [54/73] Drivers: hv: vmbus: Implement a clockevent device
reproduce:
  # apt-get install sparse
  git checkout 71123d54fb2346c7652d8d05dac2cee28cd69954
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/hv/vmbus_drv.c:582:6: sparse: symbol 'hv_process_timer_expiration' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
