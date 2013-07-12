Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab3GLNWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:22:47 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48637
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964775Ab3GLNWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:22:46 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: balloon: Fix some issues in the balloon driver 
Date: Fri, 12 Jul 2013 06:54:52 -0700
Message-Id: <1373637292-25855-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adresses a couple of issues discovered in the balloon driver:

1. Prevent stale pressure report being posted.
2. If memory is not brought online within the allowed time,
   do not roll back hot add state if hot add succeeded.

K. Y. Srinivasan (2):
  Drivers: hv: balloon: Fix a bug in the hot-add code
  Drivers: hv: balloon: Do not post pressure status if interrupted

 drivers/hv/hv_balloon.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.7.4.1

