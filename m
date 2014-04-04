Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaDDTlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:41:10 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:53036 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaDDTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:41:07 -0400
X-LoopCount0: from 10.208.46.70
X-IronPort-AV: E=Sophos;i="4.97,796,1389765600"; 
   d="scan'208";a="588668738"
From: Mario Limonciello <mario_limonciello@dell.com>
To: matthew.garrett@nebula.com
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: [PATCH 0/1] Fix memory errors found by intel buildbot
Date: Fri,  4 Apr 2014 14:40:19 -0500
Message-Id: <1396640420-9777-1-git-send-email-mario_limonciello@dell.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel build bot caught a few errors with alienware_wmi not testing for
bad results when allocated memory.  Here's the fixes for them.

Mario Limonciello (1):
  alienware-wmi: cover some scenarios where memory allocations would
    fail

 drivers/platform/x86/alienware-wmi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
1.9.1

