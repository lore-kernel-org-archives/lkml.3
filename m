Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaBPXqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:46:53 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46489
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaBPXqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:46:51 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] Drivers: net: hyperv: Cleanup the hyper-V networking code 
Date: Sun, 16 Feb 2014 16:38:03 -0800
Message-Id: <1392597483-13307-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some unnecessary code and some general cleanup.

K. Y. Srinivasan (3):
  Drivers: net: hyperv: Get rid of the rndis_filter_packet structure
  Drivers: net: hyperv: Cleanup the receive path
  Drivers: net: hyperv: Cleanup the netvsc receive callback functio

 drivers/net/hyperv/hyperv_net.h   |    8 +---
 drivers/net/hyperv/netvsc.c       |   62 +++++++++++++-----------------------
 drivers/net/hyperv/netvsc_drv.c   |    2 +-
 drivers/net/hyperv/rndis_filter.c |   41 ++----------------------
 4 files changed, 29 insertions(+), 84 deletions(-)

-- 
1.7.4.1

