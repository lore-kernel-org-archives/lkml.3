Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3I0BKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:10:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:1289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab3I0BKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,989,1371106800"; 
   d="scan'208";a="407851625"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH CHAR-MISC-NEXT 4/4] Intel MIC Header File warning fix.
Date: Thu, 26 Sep 2013 18:10:23 -0700
Message-Id: <a12a4d52202e0511d03a0e6b85ef5d70348d64cf.1380241770.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1380241770.git.sudeep.dutt@intel.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/include/linux/mic_ioctl.h:37:
found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 include/uapi/linux/mic_ioctl.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/mic_ioctl.h b/include/uapi/linux/mic_ioctl.h
index 0e6cbf3..7fabba5 100644
--- a/include/uapi/linux/mic_ioctl.h
+++ b/include/uapi/linux/mic_ioctl.h
@@ -21,6 +21,8 @@
 #ifndef _MIC_IOCTL_H_
 #define _MIC_IOCTL_H_
 
+#include <linux/types.h>
+
 /*
  * mic_copy - MIC virtio descriptor copy.
  *
-- 
1.8.2.1

