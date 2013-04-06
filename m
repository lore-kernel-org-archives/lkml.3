Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163130Ab3DFBry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 21:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162960Ab3DFBrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 21:47:53 -0400
Date: Sat, 6 Apr 2013 02:47:48 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device-mapper fixes for 3.9-rc6
Message-ID: <20130406014748.GA10444@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
References: <20130321022625.GA25054@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321022625.GA25054@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.9-fixes-2
 
to get the following device-mapper fixes for 3.9.

Thanks,
Alasdair
 
----------------------------------------------------------------
A pair of patches to fix the writethrough mode of the device-mapper
cache target when the device being cached is not itself wrapped with
device-mapper.

----------------------------------------------------------------
Darrick J. Wong (1):
      dm cache: fix writes to cache device in writethrough mode

Mike Snitzer (1):
      dm cache: reduce bio front_pad size in writeback mode

 drivers/md/dm-cache-target.c |   51 +++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 13 deletions(-)
