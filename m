Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaH1IIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:08:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:3926 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934203AbaH1IId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378043433"
From: Darren Hart <dvhart@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 0/1]: Update platform-drivers-x86 maintainer and tree
Date: Thu, 28 Aug 2014 01:07:52 -0700
Message-Id: <1409213273-60997-1-git-send-email-dvhart@infradead.org>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Per my discussion with Matthew, I have agreed to take on maintenance of
platform-drivers-x86.

I have setup a new tree:
git://git.infradead.org/users/dvhart/linux-platform-drivers-x86.git

It currently has the one revert patch I know is pending for this branch in the
for-linus branch and I've tagged it for-linus-3.17-rc2. However, as I'll be
traveling for the next few days without much access to email, I thought it best
not to send my first pull request and run..

Instead, I'm including the MAINTAINER update here, for Matthew mostly, and a
preview of what I have queued for Linus for early next week.

Thanks,

Darren Hart
Intel Open Source Technology Center

