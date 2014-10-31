Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaJaGEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:04:30 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60878 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaJaGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:04:28 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9V64Npf010671, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] Code adjustment
Date: Fri, 31 Oct 2014 14:03:53 +0800
Message-ID: <1394712342-15778-75-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust some codes to make them more reasonable.

Hayes Wang (3):
  r8152: remove the duplicate the init for the list of rx_done
  r8152: clear the flag of SCHEDULE_TASKLET in tasklet
  r8152: check RTL8152_UNPLUG and netif_running before autoresume

 drivers/net/usb/r8152.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

-- 
1.9.3

