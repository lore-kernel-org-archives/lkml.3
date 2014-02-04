Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaBDK0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:26:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37501 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbaBDK0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:26:32 -0500
X-IronPort-AV: E=Sophos;i="4.95,778,1384300800"; 
   d="scan'208";a="99579771"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] xen-blk: bug fixes
Date: Tue, 4 Feb 2014 11:26:11 +0100
Message-ID: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contain blkback bug fixes for memory leaks (patches 1 and 
2) and a race (patch 3). Patch 4 removes blkif_request_segment_aligned 
since its memory layout is exactly the same as blkif_request_segment 
and should introduce no functional change.

All patches should be backported to stable branches, although the last 
one is not a functional change it will still be nice to have it for 
code correctness.
