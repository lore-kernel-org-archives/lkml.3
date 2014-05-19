Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaESTLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:11:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37127 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:11:41 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/5] usb: gadget: net2280: Code cleanout
Date: Mon, 19 May 2014 21:11:28 +0200
Message-Id: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


net2280 was developed before the CodeStyle was enforced. This set of patches
intend to improve the readability of the code.

This set of patches should be applied after:

[PATCH 5/5] usb: gadget: net2280: Use module_pci_driver macro

In order to avoid mail list spamming I have not resubmitted the 10 patches, only
the new ones.


Ricardo Ribalda Delgado (5):
  usb: gadget: net2280: Refactor queues_show
  usb: gadget: net2280: Use S_I macros
  usb: gadget: net2280: Pass checkpacth.pl test
  usb: gadget: net2280: Code Cleanup
  usb: gadget: net2280: Use pr_* function

 drivers/usb/gadget/net2280.c | 1329 +++++++++++++++++++++---------------------
 drivers/usb/gadget/net2280.h |   97 ++-
 2 files changed, 695 insertions(+), 731 deletions(-)

-- 
2.0.0.rc2

