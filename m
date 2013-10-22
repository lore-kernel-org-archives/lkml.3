Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3JVPqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:46:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:12944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3JVPq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:46:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378361372"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Some kbuild fixes
Date: Tue, 22 Oct 2013 08:46:20 -0700
Message-Id: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are some generic Kbuild fixes from the LTO tree.
These are not really LTO specific and can be applied indepdently.

-Andi
