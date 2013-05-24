Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3EXQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:41:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62134 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3EXQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:41:25 -0400
MIME-Version: 1.0
Date: Fri, 24 May 2013 11:41:24 -0500
Message-ID: <CAH2r5msaDUJZhYs-Vjth54O45+TuKE2fytCHAsvEU611Vv56hg@mail.gmail.com>
Subject: [GIT] CIFS Fix
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One cifs fix to merge now - fixes possible DFS oops (I expect to
request a merge of 4 additional cifs fixes next week).

The following changes since commit ebb37277796269da36a8bc5d72ed1e8e1fb7d34b:

  Merge branch 'for-3.10/drivers' of git://git.kernel.dk/linux-block
(2013-05-08 11:51:05 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: only set ops for inodes in I_NEW state

 fs/cifs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Thanks,

Steve
