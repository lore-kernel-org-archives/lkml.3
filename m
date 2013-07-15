Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3GOFAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:00:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53032
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3GOFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:00:10 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/2] Drivers: hv: balloon: Fix some issues in the balloon driver  
Date: Sun, 14 Jul 2013 22:37:49 -0700
Message-Id: <1373866669-9314-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adresses a couple of issues discovered in the balloon driver:

1. Prevent stale pressure report being posted.
2. If memory is not brought online within the allowed time,
   do not roll back hot add state if hot add succeeded.

In this version of the patch set, I have added additional comments to the
patch: 0001-Drivers-hv-balloon-Fix-a-bug-in-the-hot-add-code.patch based on
the comments from Ben Hutchings <ben@decadent.org.uk>.

K. Y. Srinivasan (2):
  Drivers: hv: balloon: Fix a bug in the hot-add code
  Drivers: hv: balloon: Do not post pressure status if interrupted

 drivers/hv/hv_balloon.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

-- 
1.7.4.1

