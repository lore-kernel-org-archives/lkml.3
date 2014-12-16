Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaLPUKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:10:53 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:35696
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaLPUKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:10:52 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues  
Date: Tue, 16 Dec 2014 13:21:20 -0800
Message-Id: <1418764880-11183-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches in this series are a resend; these were submitted
some months ago and as far as I know, there were no outstanding issues.

Win8 and win8 r2 hosts do support SPC-3 features but claim SPC-2 compliance.
This issue is fixed here as well.

K. Y. Srinivasan (4):
  Drivers: scsi: storvsc: In responce to a scan event, scan the host
  Drivers: scsi: storvsc: Force discovery of LUNs that may have been
    removed.
  Drivers: scsi: storvsc: Fix a bug in storvsc limits
  Drivers: scsi: storvsc: Force SPC-3 compliance on win8 and win8 r2
    hosts

 drivers/scsi/storvsc_drv.c |   71 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 57 insertions(+), 14 deletions(-)

-- 
1.7.4.1

