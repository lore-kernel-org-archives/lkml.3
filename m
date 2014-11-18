Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaKRM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:58:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:34558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaKRM64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:58:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="624205542"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: wsa@the-dreams.de, julia.lawall@lip6.fr, dan.carpenter@oracle.com,
        johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v2 0/4] dln2 fixes for ib-mfd-gpio-i2c-3.19
Date: Tue, 18 Nov 2014 14:57:56 +0200
Message-Id: <1416315480-2053-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Here are a few fixes for the DLN2 drivers for the ib-mfd-gpio-i2c-3.19 branch.

Thanks,
Tavi

Changes since v1:

 * fix coding style (add braces) and remove redundant ret = 0 statement

 * add two more fixes for issues reported by Dan Carpenter


Dan Carpenter (1):
  mfd: dln2: a couple endian fixes

Octavian Purdila (3):
  mfd: dln2: fix _dln2_transfer return code
  i2c: dln2: simplify return flow for dln2_i2c_enable
  mfd: dln2: add a limit check for invalid echo

 drivers/i2c/busses/i2c-dln2.c |  7 +------
 drivers/mfd/dln2.c            | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 12 deletions(-)

-- 
1.9.1

