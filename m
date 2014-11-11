Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaKKMVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:21:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:62222 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaKKMVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:21:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414783176"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: laurentiu.palcu@intel.com, johan@kernel.org, wsa@the-dreams.de,
        julia.lawall@lip6.fr, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 0/2] fixes for ib-mfd-gpio-i2c-3.19
Date: Tue, 11 Nov 2014 14:20:55 +0200
Message-Id: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

A couple of patches that fixes a coccinelle warning found by Julia and
kbuild test robot. They are not critical and I don't know if they must
be pull through ib-mfd-gpio-i2c-3.19, please let me know if I need to
submit them elsewhere.

Thanks,
Tavi


Octavian Purdila (2):
  mfd: dln2: fix _dln2_transfer return code
  i2c: dln2: simplify return flow for dln2_i2c_enable

 drivers/i2c/busses/i2c-dln2.c | 7 +------
 drivers/mfd/dln2.c            | 3 ++-
 2 files changed, 3 insertions(+), 7 deletions(-)

-- 
1.9.1

