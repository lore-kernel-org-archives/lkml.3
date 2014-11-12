Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966592AbaKLCFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:05:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43116 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaKLCFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:05:23 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAC25IXf029927, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 0/3] Code adjustment
Date: Wed, 12 Nov 2014 10:05:02 +0800
Message-ID: <1394712342-15778-91-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-79-Taiwan-albertk@realtek.com>
References: <1394712342-15778-79-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
 Remove the test_bit for patch #2.

v2:
 Correct the spelling error for the comment of patch #3.

v1:
Adjust some codes to make them more reasonable.

Hayes Wang (3):
  r8152: remove the duplicate init for the list of rx_done
  r8152: clear the flag of SCHEDULE_TASKLET in tasklet
  r8152: check RTL8152_UNPLUG and netif_running before autoresume

 drivers/net/usb/r8152.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

-- 
1.9.3

