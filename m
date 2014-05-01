Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaEAWpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:45:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:12872 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaEAWpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:45:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,967,1389772800"; 
   d="scan'208";a="532214939"
From: Andi Kleen <andi@firstfloor.org>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Remove __visible from asmlinkage for 3.15
Date: Fri,  2 May 2014 00:44:35 +0200
Message-Id: <1398984278-29319-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the earlier patchkit based on Linus original feedback.
It should be merged for 3.15 to finally quell the asmlinkage warnings
that are visible in various configurations.

This reverts the asm linkage __visible patch.
Then adds __visible explicitly everywhere where it is needed.

-Andi

