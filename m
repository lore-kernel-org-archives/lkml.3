Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaHZSB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:01:58 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53872
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaHZSB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:01:57 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Drivers: hv: vmbus: Eliminate calls to BUG_ON() 
Date: Tue, 26 Aug 2014 12:05:22 -0700
Message-Id: <1409079922-16560-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the channel management code and eliminate calls to BUG_ON()

K. Y. Srinivasan (4):
  Drivers: hv: vmbus: Cleanup vmbus_post_msg()
  Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
  Drivers: hv: vmbus: Cleanup vmbus_close_internal()
  Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()

 drivers/hv/channel.c    |   48 +++++++++++++++++++++++++++++++---------------
 drivers/hv/connection.c |   13 +++++++++--
 2 files changed, 42 insertions(+), 19 deletions(-)

-- 
1.7.4.1

