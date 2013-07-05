Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3GEOwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:52:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:61435 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806Ab3GEOwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:52:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1002,1363158000"; 
   d="scan'208";a="360967339"
Message-ID: <1373036147.2711.60.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.11-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Jul 2013 17:55:47 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus!

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.11-rc1

for you to fetch changes up to beadadfa5467e09e36891f39cae1f5d8d3bbf17e:

  UBIFS: correct mount message (2013-05-10 17:07:01 +0300)

----------------------------------------------------------------
Only a single patch which fixes a message.

----------------------------------------------------------------
Richard Genoud (1):
      UBIFS: correct mount message

 fs/ubifs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Best Regards,
Artem Bityutskiy

