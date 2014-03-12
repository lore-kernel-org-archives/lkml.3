Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaCLMk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:40:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45398 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaCLMkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:25 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2CCeLhX010831, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next 0/2] parameter modification
Date: Wed, 12 Mar 2014 20:39:57 +0800
Message-ID: <1394526259-5513-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
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

Hayes Wang (2):
  r8152: add CONFIG_RTL8152_EARLY_AGG_SUPER
  r8152: reduce the numbers of the bulks

 drivers/net/usb/Kconfig | 11 +++++++++++
 drivers/net/usb/r8152.c |  8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

-- 
1.8.4.2

