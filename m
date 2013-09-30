Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3I3UcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:32:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab3I3U3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029765"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Subject: Various static checker fixes
Date: Mon, 30 Sep 2013 13:29:01 -0700
Message-Id: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was playing around with LLVM's static checker. Here are some fixes
from reviewing the output on a kernel build.

Some merely shut up the checker -- it is technically right, but
the problem is not a real bug as far as I can tell. Still it's
cleaner/clearer to avoid uninitialized variables and similar.

A few others are real bugs.

-Andi

