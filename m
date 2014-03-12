Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaCLQJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:09:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8564 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbaCLQI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:08:26 -0400
X-IronPort-AV: E=Sophos;i="4.97,639,1389744000"; 
   d="scan'208";a="109219598"
From: Felipe Franciosi <felipe@paradoxo.org>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 0/2] mtip32xx: Fix arch-specific driver issues
Date: Wed, 12 Mar 2014 16:05:46 +0000
Message-ID: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix a couple of issues with the Micron P320 driver.
The first is an issue on 32-bit architectures where unecessary bouncing of
requests causes really really bad performance. The second regards a problem
on architectures where DMA unmapping has side effects.

