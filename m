Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3GEOxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:53:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:15829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab3GEOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:53:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1002,1363158000"; 
   d="scan'208";a="365308902"
Message-ID: <1373036223.2711.62.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.11-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Jul 2013 17:57:03 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus!

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.11-rc1

for you to fetch changes up to 83ff59a066637a6c28844bbf43009459408240f4:

  UBI: support ubi_num on mtd.ubi command line (2013-07-01 08:32:57 +0300)

----------------------------------------------------------------
A couple of fixes and clean-ups, allow for assigning user-defined
UBI device numbers when attaching MTD devices by using the "mtd="
module parameter.

----------------------------------------------------------------
Brian Pomerantz (1):
      UBI: fastmap break out of used PEB search

Mike Frysinger (4):
      UBI: drop redundant "UBI error" string
      UBI: do not abort init when ubi.mtd devices cannot be found
      UBI: document UBI_IOCVOLUP better in user header
      UBI: support ubi_num on mtd.ubi command line

 drivers/mtd/ubi/build.c     | 59 ++++++++++++++++++++++++++++++++++++++++-------------------
 drivers/mtd/ubi/fastmap.c   |  4 +++-
 include/uapi/mtd/ubi-user.h |  5 ++++-

-- 
Best Regards,
Artem Bityutskiy


