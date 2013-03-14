Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3CNKep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:34:45 -0400
Received: from mout.web.de ([212.227.15.4]:65305 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab3CNKen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:34:43 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 0/3] ACPI video: Fix brightness control initialization sequence
Date: Thu, 14 Mar 2013 11:34:21 +0100
Message-Id: <1363257264-15984-1-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
X-Provags-ID: V02:K0:vYqE3TvrDKOLUIhJKHyNXGIpRbsTYoKld4yKEC7w+Ui
 TgxOXESzaoDrbmNqDd+7M8s9cyILbAoCXfkg6KUIX/e/p+h6cW
 V3ydr9s7/WVac6AFlQ7Ek3ytBLoeWtQZ55UFn/rziCwg9r6+bR
 8mTJbJMOtZuUcrOMHj26gfMoitL8Sd7V1rOou+0ZmALML3qWsx
 d9isEzkP6h2Q7BXG8kjKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a some logic mistakes in the brightness control
initialization sequence of the ACPI video driver. This should make
the initialization (and as a consequence in-kernel brightness control)
work for a number of laptops. One example that was broken before is the
Dell Inspiron 15R SE (7520).

Regards,

Danny

Danny Baumann (3):
  ACPI video: Fix brightness control initialization for some laptops.
  ACPI video: Make logic a little easier to understand.
  ACPI video: Fix applying indexed initial brightness value.

 drivers/acpi/video.c | 59 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

-- 
1.8.1.4

