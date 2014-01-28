Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaA1RoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:44:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:46844 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbaA1Rn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:43:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97353079"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: xen-blkback: bug fixes
Date: Tue, 28 Jan 2014 18:43:32 +0100
Message-ID: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkback bug fixes for memory leaks (patches 1 and 2) and a race 
(patch 3).
