Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaAaFvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 00:51:14 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55940 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaAaFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 00:51:12 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Gauthier <marc@cadence.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 0/4] OpenCores 10/100 MAC ethtool operations
Date: Fri, 31 Jan 2014 09:41:03 +0400
Message-Id: <1391146867-30508-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Ben, Florian and everybody,

this series implements ethtool callbacks for the ethoc driver as was
requested by Florian.

Changes v1->v2:
- fix {get,set}_settings return code in case there's no PHY;
- fix set_ringparam: check ring sizes, change ring sizes on the fly.

Max Filippov (4):
  net: ethoc: implement basic ethtool operations
  net: ethoc: implement ethtool get/set settings
  net: ethoc: implement ethtool get registers
  net: ethoc: implement ethtool get/set ring parameters

 drivers/net/ethernet/ethoc.c | 101 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

-- 
1.8.1.4

