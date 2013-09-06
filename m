Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab3IFDko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:40:44 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39427 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3IFDkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:40:43 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r863eUoW002074, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <micky_ching@realsil.com.cn>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
Date: Fri, 6 Sep 2013 11:40:29 +0800
Message-ID: <cover.1378437776.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

v2:
Name those new-added register values

Wei WANG (1):
  mfd: rtsx: Modify rts5249_optimize_phy

 drivers/mfd/rts5249.c        |   35 ++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h |   43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 2 deletions(-)

-- 
1.7.9.5

