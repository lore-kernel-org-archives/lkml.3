Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbbAYIQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:16:18 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39523 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbAYIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:15:14 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH v3 3/5] usb: dwc3: add revision number DWC3_REVISION_290A and DWC3_REVISION_300A
Date: Sun, 25 Jan 2015 16:13:26 +0800
Message-Id: <1422173608-24355-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the contstant for v2.90a and v3.00a dwc3 IP detection

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 drivers/usb/dwc3/core.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4bb9aa6..46f9f9a 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -776,6 +776,8 @@ struct dwc3 {
 #define DWC3_REVISION_260A	0x5533260a
 #define DWC3_REVISION_270A	0x5533270a
 #define DWC3_REVISION_280A	0x5533280a
+#define DWC3_REVISION_290A	0x5533290a
+#define DWC3_REVISION_300A	0x5533300a
 
 	enum dwc3_ep0_next	ep0_next_event;
 	enum dwc3_ep0_state	ep0state;
-- 
1.7.9.5

