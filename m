Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab3GLNw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:52:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40414 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861Ab3GLNwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:52:25 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>,
        Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Subject: [PATCH v1 0/2] PM / AVS: interrupt handling fixes
Date: Fri, 12 Jul 2013 16:52:01 +0300
Message-ID: <1373637123-1152-1-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Could you please take a look to the following patch series.
It consists of two patches, which are needed for proper
SmartReflex Interrupt handling.

Based on Linux v3.10. Verified on OMAP4430.

Thank you in advance.

Regards,
Andrii

Nishanth Menon (2):
  PM / AVS: SmartReflex: fix interrupt disable sequence
  PM / AVS: SmartReflex: disable spamming interrupts

 drivers/power/avs/smartreflex.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
1.7.9.5

