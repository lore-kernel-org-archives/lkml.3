Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaENSIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:08:07 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:23592 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbaENSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:08:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq02ABewc1NXQ68k/2dsb2JhbABZgwaBYQFfqigEAQEBAQEBBQGaHYElF3SCZhwjGIECJIhYAdFThVSIeoRHAQOZUAGTFIM4Ow
Date: Wed, 14 May 2014 20:08:03 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe <joe@perches.com>
Subject: [PATCH V2 0/3] EFS Logging clean-up
Message-Id: <20140514200803.6a13de68b359695148d574c7@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts EFS to current logging functions.
I hope things will be more clear with a generic 3 steps conversion.
Note that pr_debug conversion in this case is straightforward.

V2: Remove ifdef debug around pr_debug

Fabian Frederick (3):
  FS/EFS: convert printk to pr_foo()
  FS/EFS: add pr_fmt / use __func__
  FS/EFS: convert printk(KERN_DEBUG to pr_debug

 fs/efs/dir.c   | 18 ++++++++++--------
 fs/efs/efs.h   |  6 ++++++
 fs/efs/file.c  | 14 +++++---------
 fs/efs/inode.c | 42 ++++++++++++++++++++----------------------
 fs/efs/namei.c |  8 +++++---
 fs/efs/super.c | 42 ++++++++++++++++++++----------------------
 6 files changed, 66 insertions(+), 64 deletions(-)

-- 
1.9.1
