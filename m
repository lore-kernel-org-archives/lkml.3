Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3BAAxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 19:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3BAAxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 19:53:12 -0500
Date: Fri, 1 Feb 2013 00:53:08 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Daniel Browning <db@kavod.com>,
        linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
Subject: [git pull] Further device-mapper fixes for 3.8
Message-ID: <20130201005308.GG3228@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, Daniel Browning <db@kavod.com>,
	linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.8-fixes-2

to get the following device-mapper fixes for 3.8.
 
Thanks,
Alasdair
  
----------------------------------------------------------------
A fix for stacked dm thin devices and a fix for the new dm WRITE SAME
support.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm: fix write same requests counting

Mike Snitzer (1):
      dm thin: fix queue limits stacking

 drivers/md/dm-thin.c |   13 +------------
 drivers/md/dm.c      |    6 ++++--
 2 files changed, 5 insertions(+), 14 deletions(-)
