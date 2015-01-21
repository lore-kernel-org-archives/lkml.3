Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbbAUXe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:34:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:20670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbbAUXeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:34:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,444,1418112000"; 
   d="scan'208";a="640677354"
Date: Thu, 22 Jan 2015 07:34:04 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [ext3:quota_interface 18/31] fs/quota/quota.c:69:14: sparse: symbol
 'qtype_enforce_flag' was not declared. Should it be static?
Message-ID: <201501220757.KwzDB2MB%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git quota_interface
head:   9ba4f6c1cc8a43d25369db0f43af9220bfcd1b92
commit: 34c3165e700a877be816f226c5b14fe90919e74e [18/31] quota: Wire up ->quota_{enable,disable} callbacks into Q_QUOTA{ON,OFF}
reproduce:
  # apt-get install sparse
  git checkout 34c3165e700a877be816f226c5b14fe90919e74e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/quota/quota.c:69:14: sparse: symbol 'qtype_enforce_flag' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
