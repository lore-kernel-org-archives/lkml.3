Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab3CRWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:06:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55896 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab3CRWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:06:47 -0400
X-Sasl-enc: oEvMgm+miQeImwHK3dvBWtgIeYtF/xp9zS4uNjNS/8Jg 1363644405
From: Alan Ott <alan@signal11.us>
To: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH 0/4] Misc MRF24J40 Fixes
Date: Mon, 18 Mar 2013 18:06:39 -0400
Message-Id: <1363644403-11003-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are fairly straight-forward.

Alan Ott (4):
  mrf24j40: pinctrl support
  mrf24j40: Warn if transmit interrupts timeout
  mrf24j40: Increase max SPI speed to 10MHz
  mrf24j40: Fix byte-order of IEEE address

 drivers/net/ieee802154/mrf24j40.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.7.11.2

