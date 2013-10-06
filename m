Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3JFDPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:15:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56421 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759Ab3JFDPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:15:30 -0400
X-Sasl-enc: raxLqtJPmzkJGz0KbJ9/bCzvdzO3sl2PB2cOuBSJTHyz 1381029327
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Alexander Aring <alex.aring@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/2] 6lowpan default hardware address
Date: Sat,  5 Oct 2013 23:15:17 -0400
Message-Id: <1381029319-6835-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Aring suggested that devices desired to be linked to 6lowpan
be checked for actually being of type IEEE802154, since IEEE802154 devices
are all that are supported by 6lowpan at present.

Alan Ott (2):
  6lowpan: Only make 6lowpan links to IEEE802154 devices
  6lowpan: Sync default hardware address of lowpan links to their wpan

 net/ieee802154/6lowpan.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
1.8.1.2

