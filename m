Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaGGWdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:33:43 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:45277
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGGWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:33:42 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv 
Date: Mon,  7 Jul 2014 16:33:57 -0700
Message-Id: <1404776037-8644-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a bug in the VMBUS driver that dispatches driver specific
callback as well as a bug in the KVP code.

K. Y. Srinivasan (2):
  Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
  Drivers: hv: util: Fix a bug in the KVP code

 drivers/hv/connection.c |    8 ++++++--
 drivers/hv/hv_kvp.c     |   17 ++++++++++++++---
 drivers/hv/hv_util.c    |    2 +-
 3 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.7.4.1

