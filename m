Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3IJVCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3IJVCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:02:47 -0400
Date: Tue, 10 Sep 2013 17:02:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lock held returning to user space (i_mutex_dir_key)
Message-ID: <20130910210237.GA15371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

================================================
[ BUG: lock held when returning to user space! ]
3.11.0+ #64 Not tainted
------------------------------------------------
trinity-child2/8333 is leaving the kernel with locks still held!
1 lock held by trinity-child2/8333:
 #0:  (&type->i_mutex_dir_key#3){+.+.+.}, at: [<ffffffff811c7fce>] mountpoint_last+0x4e/0x1a0



