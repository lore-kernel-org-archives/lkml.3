Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaBZNQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:16:53 -0500
Received: from sh.osrg.net ([192.16.179.4]:45076 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaBZNQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:16:52 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/2] nilfs2: update web site information
Date: Wed, 26 Feb 2014 22:12:01 +0900
Message-Id: <1393420323-18255-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Wed, 26 Feb 2014 22:16:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please add this patchset to the queue for the next merge window.

We recently moved web site of nilfs project.  And, these patches
update the site information in MAINTAINERS file and document file.

The MAINTAINERS file update is written as a diff to the previous patch
"nilfs2: update MAINTAINERS file entries" (to make folding it into the
original patch easy).

Thanks,
Ryusuke Konishi
--
Ryusuke Konishi (2):
      nilfs2: update MAINTAINERS file entries fix
      nilfs2: update project's web site in nilfs2.txt

 Documentation/filesystems/nilfs2.txt |    5 ++---
 MAINTAINERS                          |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

