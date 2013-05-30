Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030334Ab3E3KF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:05:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968038Ab3E3KFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:05:54 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/2] Update aops documentation
Date: Thu, 30 May 2013 11:05:46 +0100
Message-Id: <1369908348-7943-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch adds an address_space operation that filesystems may
> > optionally use to check if a page is really dirty or really under
> > writeback.
> 
> address_space_operations methods are Documented in
> Documentation/filesystems/vfs.txt ;)

I could whinge that the aops docs are already out of date but fixing it
takes less time than coming up with excuses :)

 Documentation/filesystems/vfs.txt | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
1.8.1.4

