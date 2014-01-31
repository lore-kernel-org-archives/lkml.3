Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaAaPkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:40:04 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:46458
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbaAaPkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:40:01 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: net: hyperv: Cleanup the recive path 
Date: Fri, 31 Jan 2014 08:24:38 -0800
Message-Id: <1391185478-5655-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor cleanup of the receive path. Get rid of unnecessary
indirection as well as unnecessary re-establishment of state.

K. Y. Srinivasan (2):
  Drivers: net: hyperv: Get rid of the rndis_filter_packet structure
  Drivers: net: hyperv: Cleanup the receive path

 drivers/net/hyperv/hyperv_net.h   |    6 -----
 drivers/net/hyperv/netvsc.c       |   29 +++++++++++--------------
 drivers/net/hyperv/netvsc_drv.c   |    2 +-
 drivers/net/hyperv/rndis_filter.c |   41 ++----------------------------------
 4 files changed, 17 insertions(+), 61 deletions(-)

-- 
1.7.4.1

