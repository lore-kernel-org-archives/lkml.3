Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab3FSArB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:47:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:33882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab3FSArA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:47:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,892,1363158000"; 
   d="scan'208";a="256967040"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] DMA Offload fixes 
Date: Tue, 18 Jun 2013 17:46:51 -0700
Message-Id: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These 2 patches address issues encountered while attempting to use the
DMA subsystem in the NTB driver.  While outside of the scope of that
patch (which will be forthcoming), these fixes are necessary to get it
working.

Thanks,
Jon
