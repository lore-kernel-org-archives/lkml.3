Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3FGUOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:14:36 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45569 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:14:34 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 15:14:33 -0500
Message-ID: <CAH2r5muw-8mpY68trpPuMjm8+CRwJ5vmt80fTTUsZOTxwXsiKw@mail.gmail.com>
Subject: [GIT] CIFS Fix
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix one byte buffer overrun with prefixpaths on cifs mounts which can
cause a problem with mount depending on the string length.

The following changes since commit a93cb29acaa8f75618c3f202d1cf43c231984644:

  Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux (2013-05-31 16:04:05
+1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-3.10

Jeff Layton (1):
      cifs: fix off-by-one bug in build_unc_path_to_root

 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
