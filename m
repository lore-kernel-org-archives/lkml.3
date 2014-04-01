Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaDAVlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:41:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:6265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaDAVlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:41:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,775,1389772800"; 
   d="scan'208";a="512660013"
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Updated asmlinkage patch v2
Date: Tue,  1 Apr 2014 23:40:09 +0200
Message-Id: <1396388412-22573-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the asmlinkage contains __visible change.

I removed the header declarations Linus didn't like. This 
removed the crypto patch and made everything a lot smaller
and simpler.

I thought it was needed based on earlier experiments,
but on rechecking Linus was right and the header declarations
are never needed.

Did some basic sanity checks with LTO and everything
works (still need the three other LTO patches to build)

Please consider applying.

-Andi

