Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaCMMGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:06:00 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48209 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaCMMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:05:58 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2DC5txi012663, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next v3 0/2] parameter modification
Date: Thu, 13 Mar 2014 20:05:40 +0800
Message-ID: <1394712342-15778-1-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add opportunity to change the default setting and reduce the tx/rx
buffers.

v2: modify the patch #1 to let the value readable.

v3: modify the definition of the EARLY_AGG_SUPER for patch #1.

Hayes Wang (2):
  r8152: add RTL8152_EARLY_AGG_TIMEOUT_SUPER
  r8152: reduce the numbers of the bulks

 drivers/net/usb/Kconfig | 11 +++++++++++
 drivers/net/usb/r8152.c | 10 ++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

-- 
1.8.4.2

