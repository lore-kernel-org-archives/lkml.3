Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaLSCBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:6706 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaLSCBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="640050918"
Date: Fri, 19 Dec 2014 09:56:59 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: kbuild-all@01.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [hisi:integration-hilt-linux-linaro 17/28]
 drivers/input/touchscreen/atmel_mXT224E.c:460:5: sparse: symbol
 'i2c_atmel_read' was not declared. Should it be static?
Message-ID: <201412190926.IzkyYvvl%fengguang.wu@intel.com>
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

tree:   git://github.com/hisilicon/linux-hisi integration-hilt-linux-linaro
head:   791a2af480ea27735b4669c623b665c5bfea9b5c
commit: d7e9caafdf706341b4165d0a8c2089e60dcebc68 [17/28] Input: enable touch atmel_mXT224E
reproduce:
  # apt-get install sparse
  git checkout d7e9caafdf706341b4165d0a8c2089e60dcebc68
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/input/touchscreen/atmel_mXT224E.c:460:5: sparse: symbol 'i2c_atmel_read' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:499:28: sparse: Variable length array is used.
>> drivers/input/touchscreen/atmel_mXT224E.c:496:5: sparse: symbol 'i2c_atmel_write' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:532:5: sparse: symbol 'i2c_atmel_write_byte_data' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:538:10: sparse: symbol 'get_object_address' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:547:9: sparse: symbol 'get_object_size' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:557:9: sparse: symbol 'get_object_size_from_address' was not declared. Should it be static?
>> drivers/input/touchscreen/atmel_mXT224E.c:847:32: sparse: symbol 'atmel_ts_get_pdata' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
