Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3JOOFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:05:03 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:41753 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309Ab3JOOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:05:00 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Subject: linux-next: Tree for Oct 15
Date: Tue, 15 Oct 2013 16:02:41 +0200
Message-Id: <1381845763-10487-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've uploaded today's linux-next tree to the master branch of the
repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131015 tag is also provided for convenience.

Gained a new conflict, but nothing too exciting. x86 and ARM default
configurations build fine. I've also used an x86 allmodconfig build to
check for build errors. Mark fixed most of those in the trees that he
created last Thursday and Friday, so I've cherry-picked them on top of
the final merge. There was one new build failure in the staging tree
that was trivial to fix so I added a patch to the tree as well.

Thierry
