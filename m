Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3ESTef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 15:34:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3ESTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 15:34:34 -0400
Date: Sun, 19 May 2013 20:34:31 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [git pull] device-mapper fix for 3.10
Message-ID: <20130519193431.GL3316@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
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
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.10-fixes

to get the following device-mapper fix for 3.10.

Thanks,
Alasdair


----------------------------------------------------------------
A patch to fix metadata resizing with device-mapper thin devices.

----------------------------------------------------------------
Alasdair G Kergon (1):
      dm thin: fix metadata dev resize detection

 drivers/md/dm-thin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
