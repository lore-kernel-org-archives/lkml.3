Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbbAFTgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:36:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:56825 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbbAFTgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:36:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,709,1413270000"; 
   d="scan'208";a="647167118"
Date: Wed, 7 Jan 2015 03:35:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [target:nvme_of 3/3]
 drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol
 'nvme_of_fabric_configfs' was not declared. Should it be static?
Message-ID: <201501070334.EgwC5iey%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvme_of
head:   40d8c11927282d59855d645b35798edd97828da5
commit: 40d8c11927282d59855d645b35798edd97828da5 [3/3] nvme_of: Initial skeleton commit
reproduce:
  # apt-get install sparse
  git checkout 40d8c11927282d59855d645b35798edd97828da5
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
