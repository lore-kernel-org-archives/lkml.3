Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaETRzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:55:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:48973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaETRzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:55:02 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 13:55:02 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,875,1392192000"; 
   d="scan'208";a="534986081"
Message-Id: <cover.1400607328.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 20 May 2014 10:35:28 -0700
Subject: [PATCH 0/2] Fix some machine check application recovery cases
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tesing recovery in mult-threaded applications showed a couple
of issues in our code.

Tony Luck (2):
  memory-failure: Send right signal code to correct thread
  memory-failure: Don't let collect_procs() skip over processes for
    MF_ACTION_REQUIRED

 mm/memory-failure.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

-- 
1.8.4.1

