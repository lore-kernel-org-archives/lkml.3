Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaAMRPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:15:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaAMRPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:15:34 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org
Subject: [RFC PATCH 0/2] hung_task: Display every hung task warning
Date: Mon, 13 Jan 2014 17:14:50 +0000
Message-Id: <1389633292-23588-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

Enable hung_task_warnings to display every hung task warning, when
set to -1. While ULONG_MAX is practically "unlimited", this patch
takes it one step further. Note: The maximum is now 2^31-1 which
should (hopefully) be sufficient.

Please let me know your thoughts.

Aaron Tomlin (2):
  sysctl: Make neg_one a standard constraint
  hung_task: Display every hung task warning

 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 9 +++++----
 kernel/sysctl.c              | 6 ++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

-- 
1.8.4.2

