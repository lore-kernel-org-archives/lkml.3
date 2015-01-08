Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbbAHSCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:02:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbbAHSCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:02:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509438710"
Date: Fri, 9 Jan 2015 02:02:00 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: kbuild-all@01.org, Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Johan Hovold <johan@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [wsa:i2c/quirks 8/11] drivers/i2c/busses/i2c-dln2.c:184:27: sparse:
 symbol 'dln2_i2c_quirks' was not declared. Should it be static?
Message-ID: <201501090243.rmSyDkOe%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/quirks
head:   b1d39af8ae21f4930854b0656aa83a83fd38049e
commit: dfd33ddaa80259918c200cfacb9076c75cf1da82 [8/11] i2c: dln2: make use of the new infrastructure for quirks
reproduce:
  # apt-get install sparse
  git checkout dfd33ddaa80259918c200cfacb9076c75cf1da82
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/i2c/busses/i2c-dln2.c:184:27: sparse: symbol 'dln2_i2c_quirks' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
