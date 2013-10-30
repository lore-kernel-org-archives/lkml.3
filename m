Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3J3JpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3J3JpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:45:18 -0400
From: Madper Xie <cxie@redhat.com>
To: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org, seiji.aguchi@hds.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, bbboson@gmail.com,
        Madper Xie <cxie@redhat.com>
Subject: [PATCH 0/2] make all stored entries accessible.
Date: Wed, 30 Oct 2013 17:44:52 +0800
Message-Id: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. checking type, id, psi, count and timespec when finding duplicate entries.
2. adding count and timestamp  for differentiating.

Madper Xie (2):
  pstore: avoid incorrectly mark entry as duplicate
  pstore: Differentiating names by adding count and timestamp

 fs/pstore/inode.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

-- 
1.8.4.2

