Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaA2T5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:57:09 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61858 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaA2T5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:57:03 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Gauthier <marc@cadence.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 0/4] OpenCores 10/100 MAC ethtool operations
Date: Wed, 29 Jan 2014 23:56:33 +0400
Message-Id: <1391025397-14965-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Florian and everybody,

this series implements ethtool callbacks for the ethoc driver as was
requested by Florian.

Max Filippov (4):
  net: ethoc: implement basic ethtool operations
  net: ethoc: implement ethtool get/set settings
  net: ethoc: implement ethtool get registers
  net: ethoc: implement ethtool get/set ring parameters

 drivers/net/ethernet/ethoc.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

-- 
1.8.1.4

