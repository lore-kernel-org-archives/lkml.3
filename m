Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaA3SC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:02:59 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49117 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaA3SC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:02:57 -0500
From: Richard Yao <ryao@gentoo.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        V9FS Develooper Mailing List 
	<v9fs-developer@lists.sourceforge.net>,
        Linux Netdev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gentoo Kernel Team <kernel@gentoo.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Matthew Thode <mthode@mthode.org>, Richard Yao <ryao@gentoo.org>
Subject: [PATCH] 9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers (second submission)
Date: Thu, 30 Jan 2014 13:02:47 -0500
Message-Id: <1391104968-10258-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my first real patch submission, which I sent out in December.
Unfortunately, I sent it to only a subset of the correct people. Time passed,
Greg Koah-Hartman was kind enough to give me some pointers and I am now sending
it back out to the correct people. My apologies to anyone who was bit by this
issue because it was not sent to the correct people sooner.

Richard Yao (1):
  9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

 net/9p/trans_virtio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.3.2

