Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaHKJ5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:57:51 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:22031 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHKJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:57:50 -0400
Message-ID: <53E8939A.7000408@imgtec.com>
Date: Mon, 11 Aug 2014 10:57:46 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-metag <linux-metag@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Metag architecture changes for v3.17
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following changes since commit
7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

which are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/metag-for-v3.17

for you to fetch changes up to f93125ae17d1d259b5aba84016db260903822194:

  metag: cachepart: Fix failure check (2014-07-18 10:36:59 +0100)

Thanks
James

----------------------------------------------------------------
Metag architecture changes for v3.17

Just a couple of minor static analysis fixes, removal of a NULL check
that should never happen, and fix an error check where an unsigned value
was being checked to see if it was negative.

----------------------------------------------------------------
Andrey Utkin (1):
      metag: cachepart: Fix failure check

Rickard Strandqvist (1):
      metag: hugetlbpage: Remove null pointer checks that could never happen

 arch/metag/kernel/cachepart.c | 4 ++--
 arch/metag/mm/hugetlbpage.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
