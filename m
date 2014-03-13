Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaCMOeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:34:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32685 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaCMOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:34:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,647,1389744000"; 
   d="scan'208";a="109581884"
From: Felipe Franciosi <felipe@paradoxo.org>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 0/2 v2] mtip32xx: Fix arch-specific performance issues
Date: Thu, 13 Mar 2014 14:34:19 +0000
Message-ID: <1394721261-2764-1-git-send-email-felipe@paradoxo.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This V2 series reintroduces blk_queue_bounce(), but also sets a correct
blk_queue_bounce_limit() during the device initialisation. I have tested
this series and confirmed that performance is good on a 32-bit dom0 on Xen.

