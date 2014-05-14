Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaENRCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:02:23 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:50173 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbaENRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:02:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsNeAN+gc1NXQ68k/2dsb2JhbABZgwaBYQVbqigEAQEBAQEBBQGaHYEjF3SCZhwjGIECJIhYAdE/hVSIeoRHAQOZUAGTFIM4Ow
Date: Wed, 14 May 2014 19:02:20 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joe <joe@perches.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 0/3] EFS Logging clean-up
Message-Id: <20140514190220.a4dcd3b33042077ec70383e1@skynet.be>
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

Fabian Frederick (3):
  FS/EFS: convert printk to pr_foo()
  FS/EFS: add pr_fmt / use __func__
  FS/EFS: convert printk(KERN_DEBUG to pr_debug

 fs/efs/dir.c   | 15 ++++++++++-----
 fs/efs/efs.h   |  6 ++++++
 fs/efs/file.c  | 14 +++++---------
 fs/efs/inode.c | 34 ++++++++++++++++++++--------------
 fs/efs/namei.c |  8 +++++---
 fs/efs/super.c | 39 +++++++++++++++++++--------------------
 6 files changed, 65 insertions(+), 51 deletions(-)

-- 
1.9.1

