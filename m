Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3LJRvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:51:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:59037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3LJRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:51:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="422425520"
From: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-next 0/1] misc: mic: bug fix for interrupt acknowledgement in MSI/INTx case
Date: Tue, 10 Dec 2013 09:50:58 -0800
Message-Id: <cover.1386636298.git.dasaratharaman.chandramouli@intel.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch contains a bug fix for the MIC driver when handling MSI/INTx
based interrupts. It would be great if this patch goes into 3.13-final.
If that is not possible, having it in the next release is also acceptable
since this patch only affects systems with MSI and INTx based interrupts
and hence not critical.

Dasaratharaman Chandramouli (1):
  misc: mic: bug fix for interrupt acknowledgement in MSI/INTx case.

 drivers/misc/mic/host/mic_device.h |  3 +++
 drivers/misc/mic/host/mic_main.c   |  2 +-
 drivers/misc/mic/host/mic_virtio.c |  2 +-
 drivers/misc/mic/host/mic_x100.c   | 36 ++++++++++++++++++++----------------
 4 files changed, 25 insertions(+), 18 deletions(-)

-- 
1.8.1.5

