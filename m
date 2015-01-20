Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbbATAE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:04:59 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:16110 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbATAE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:04:57 -0500
X-IronPort-AV: E=Sophos;i="5.09,430,1418112000"; 
   d="scan'208";a="55133445"
From: <arun.ramamurthy@broadcom.com>
To: <stern@rowland.harvard.edu>, <linux@prisktech.co.nz>,
        <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sbranden@broadcom.com>,
        <rjui@broadcom.com>, Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Subject: [PATCHv3 0/2] Added Multiple Phy support for ehci and ohci drivers
Date: Mon, 19 Jan 2015 16:05:28 -0800
Message-ID: <1421712330-11089-1-git-send-email-arun.ramamurthy@broadcom.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>

Broadcom has a chip where one ehci and ohci controller are connected
to three separate phys. This patch allows each phy to be controlled
separately.

Changes in v2:
- removed x character mistakenly introduced by manual edit of diff file 

Changes in v3:
- Addressed Alan Stern's commnents on support for non-dt cases

Arun Ramamurthy (1):
  usb: ehci-platform: add support for multiple phys per controller

 drivers/usb/host/ehci-platform.c | 82 +++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 22 deletions(-)

-- 
2.2.2

