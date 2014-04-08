Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaDHSvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:51:15 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41065
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbaDHSvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:51:13 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 0/3] Fix issues with Heper-V network offload code
Date: Tue,  8 Apr 2014 12:45:32 -0700
Message-Id: <1396986332-12098-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WS2008 R2 does not support udp checksum offload. Furthermore, ws2012 and
ws2012 r2 have issues offloading udp checksum from Linux guests.
This patch-set addresses these issues as well as other bug fixes.
Please apply.

K. Y. Srinivasan (3):
  Drivers: net: hyperv: Allocate memory for all possible per-pecket
    information
  Drivers: net: hyperv: Negotiate suitable ndis version for offload
    support
  Drivers: net: hyperv: Address UDP checksum issues

 drivers/net/hyperv/hyperv_net.h   |    1 +
 drivers/net/hyperv/netvsc.c       |    2 +-
 drivers/net/hyperv/netvsc_drv.c   |   23 +++++++++++++++++++++--
 drivers/net/hyperv/rndis_filter.c |   12 +++++++++++-
 4 files changed, 34 insertions(+), 4 deletions(-)

-- 
1.7.4.1

