Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaCFHIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:08:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:39334 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:08:33 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2678TBl024526, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] r8152: cleanups
Date: Thu, 6 Mar 2014 15:07:15 +0800
Message-ID: <1394089638-1580-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deal with some empty lines and spaces, replace some tp->netdev with netdev,
and remove the unnecessary function.

Hayes Wang (3):
  r8152: deal with the empty line and space
  r8152: replace tp->netdev with netdev
  r8152: remove rtl8152_get_stats

 drivers/net/usb/r8152.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

-- 
1.8.4.2

