Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaCGEjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:39:39 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53951
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaCGEji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:39:38 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/6] Drivers: net: hyperv: Enable various offloads 
Date: Thu,  6 Mar 2014 21:32:00 -0800
Message-Id: <1394170320-1002-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enables both checksum as well as segmentation offload.
As part of this effort I have enabled scatter gather I/O a well.

In this version of the patches, I have addressed comments from David Miller and
Dan Carpenter.

K. Y. Srinivasan (6):
  Drivers: net: hyperv: Enable scatter gather I/O
  Drivers: net: hyperv: Cleanup the send path
  Drivers: net: hyperv: Enable offloads on the host
  Drivers: net: hyperv: Enable receive side IP checksum offload
  Drivers: net: hyperv: Enable send side checksum offload
  Drivers: net: hyperv: Enable large send offload

 drivers/net/hyperv/hyperv_net.h   |  135 ++++++++++++++-
 drivers/net/hyperv/netvsc_drv.c   |  336 +++++++++++++++++++++++++++++++------
 drivers/net/hyperv/rndis_filter.c |  153 ++++++++++--------
 3 files changed, 501 insertions(+), 123 deletions(-)

-- 
1.7.4.1

