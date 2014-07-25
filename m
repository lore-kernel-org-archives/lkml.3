Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbaGYULh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:11:37 -0400
Received: from mout.gmx.net ([212.227.17.21]:50562 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaGYULg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:11:36 -0400
Date: Fri, 25 Jul 2014 22:11:26 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>
Subject: [GIT PULL] parisc fixes for v3.16
Message-ID: <20140725201126.GA1381@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:M8IYG4NJK8J9rl8XLMx5ogkTVOnEV8aP7VEQtTlQxSJNKnzKTNj
 q4OOhQnAtf3v/MHvIOdE8I72N9TbTxjc3XSGT71zvRIXx6eAVWkVqc+D0Kv7LPGP8nHZg+1
 BzqIrEG6AGMaPO2UGGvWu2EseNUta33h5vyn/CedN87Ue+4f0/ow61Ka+YLgcGh3SXHmU4P
 Z746TTVfU4bLi/ta+mNpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest parisc architecture fixes for kernel 3.16 from 
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.16-6

We have two trivial patches in here. One removes the SA_RESTORER #define since
on parisc we don't have the sa_restorer field in struct sigaction, the other
patch removes an unnecessary memset(). The SA_RESTORER removal patch is
scheduled for stable trees, since without it some userspace apps don't build.
 
Thanks,
Helge

----------------------------------------------------------------
HIMANGI SARAOGI (1):
      parisc: Eliminate memset after alloc_bootmem_pages

John David Anglin (1):
      parisc: Remove SA_RESTORER define

 arch/parisc/include/uapi/asm/signal.h | 2 --
 arch/parisc/mm/init.c                 | 1 -
 2 files changed, 3 deletions(-)
