Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbaH0WVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:21:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44230
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965168AbaH0WVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:21:38 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON() 
Date: Wed, 27 Aug 2014 16:25:05 -0700
Message-Id: <1409181905-23254-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the channel management code and eliminate calls to BUG_ON().
Also fix an error propagation bug in vmbus_open().

In this version of the patch-set, I have addressed comments from
Dan Carpenter.

K. Y. Srinivasan (5):
  Drivers: hv: vmbus: Cleanup vmbus_post_msg()
  Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
  Drivers: hv: vmbus: Cleanup vmbus_close_internal()
  Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
  Drivers: hv: vmbus: Fix a bug in vmbus_open()

 drivers/hv/channel.c    |   49 +++++++++++++++++++++++++++++++---------------
 drivers/hv/connection.c |   17 ++++++++++++---
 2 files changed, 46 insertions(+), 20 deletions(-)

-- 
1.7.4.1

