Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaGNVYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:24:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:6399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbaGNVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:24:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,660,1400050800"; 
   d="scan'208";a="543266375"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next 0/2] Fix minor issues reported in MIC drivers
Date: Mon, 14 Jul 2014 14:23:50 -0700
Message-Id: <cover.1405370827.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Himangi Saraogi (1):
  misc: mic: Introduce the managed version of ioremap

Sudeep Dutt (1):
  dma: Fix MIC X100 DMA Driver Kconfig option

 drivers/dma/Kconfig              | 3 +--
 drivers/misc/mic/card/mic_x100.c | 9 +++------
 2 files changed, 4 insertions(+), 8 deletions(-)

-- 
1.8.2.1

