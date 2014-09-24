Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaIXIfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:35:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaIXI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:16 -0400
Message-Id: <20140924081845.572814794@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a refresh of the nested sleep debug stuff which I posted as an RFC a
while back: lkml.kernel.org/r/20140804103025.478913141@infradead.org

Since then a number of issues identified by these patches have allready made
their way upstream:

    de713b57947a ("atm/svc: Fix blocking in wait loop")
    7c3af9752573 ("nfs: don't sleep with inode lock in lock_and_join_requests")

And I finally got some time to finish up these patches so we could merge them.
So please have a look and if nobody holllers we'll merge this 'soon'.

 ~ Peter

