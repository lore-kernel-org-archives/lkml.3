Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbAMUZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:25:13 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51081 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbAMUZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:25:10 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-arch@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/1] Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)
Date: Tue, 13 Jan 2015 21:25:04 +0100
Message-Id: <1421180705-44875-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011320-0021-0000-0000-00000288427A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git  tags/for-linus

for you to fetch changes up to 43239cbe79fc369f5d2160bd7f69e28b5c50a58c:

  kernel: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val) (2015-01-13 20:39:09 +0100)

----------------------------------------------------------------
As discussed on LKML http://marc.info/?l=linux-kernel&m=142081181707596
it was agreement that WRITE_ONCE(x, val) is better than ASSIGN_ONCE(val, x)

Lets change that for 3.19 as 3.19 has no user yet, but the first users
will hit linux-next soon.

----------------------------------------------------------------
Christian Borntraeger (1):
      kernel: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)

 include/linux/compiler.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

