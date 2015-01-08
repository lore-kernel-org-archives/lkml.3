Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbbAHSIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:08:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:41296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbbAHSIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:08:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,724,1413270000"; 
   d="scan'208";a="648287192"
Date: Fri, 9 Jan 2015 02:07:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: kbuild-all@01.org, Lars Poeschel <poeschel@lemonage.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [wsa:i2c/quirks 10/11] drivers/i2c/busses/i2c-viperboard.c:357:27:
 sparse: symbol 'vprbrd_quirks' was not declared. Should it be static?
Message-ID: <201501090239.gPJgrJIE%fengguang.wu@intel.com>
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
commit: 5f7099010eda61b777ba84cf9b64dc8428846d25 [10/11] i2c: viperboard: make use of the new infrastructure for quirks
reproduce:
  # apt-get install sparse
  git checkout 5f7099010eda61b777ba84cf9b64dc8428846d25
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/i2c/busses/i2c-viperboard.c:128:35: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:128:35:    expected unsigned short [unsigned] [usertype] addr
   drivers/i2c/busses/i2c-viperboard.c:128:35:    got restricted __le16 [usertype] <noident>
   drivers/i2c/busses/i2c-viperboard.c:201:34: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:201:34:    expected unsigned short [unsigned] [usertype] tf1
   drivers/i2c/busses/i2c-viperboard.c:201:34:    got restricted __le16 [usertype] <noident>
   drivers/i2c/busses/i2c-viperboard.c:202:34: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:202:34:    expected unsigned short [unsigned] [usertype] tf2
   drivers/i2c/busses/i2c-viperboard.c:202:34:    got restricted __le16 [usertype] <noident>
   drivers/i2c/busses/i2c-viperboard.c:237:35: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:237:35:    expected unsigned short [unsigned] [usertype] addr
   drivers/i2c/busses/i2c-viperboard.c:237:35:    got restricted __le16 [usertype] <noident>
   drivers/i2c/busses/i2c-viperboard.c:300:35: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:300:35:    expected unsigned short [unsigned] [usertype] len
   drivers/i2c/busses/i2c-viperboard.c:300:35:    got restricted __le16 [usertype] <noident>
   drivers/i2c/busses/i2c-viperboard.c:325:35: sparse: incorrect type in assignment (different base types)
   drivers/i2c/busses/i2c-viperboard.c:325:35:    expected unsigned short [unsigned] [usertype] len
   drivers/i2c/busses/i2c-viperboard.c:325:35:    got restricted __le16 [usertype] <noident>
>> drivers/i2c/busses/i2c-viperboard.c:357:27: sparse: symbol 'vprbrd_quirks' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
