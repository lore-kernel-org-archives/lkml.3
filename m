Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3KTS26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab3KTS25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:28:57 -0500
Date: Wed, 20 Nov 2013 19:30:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] proc: proc_task_readdir/first_tid fixes/cleanups
Message-ID: <20131120183009.GA12193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric, to remind, you already reviewed these changes and acked
them in May. They were dropped because they conflicted with Al's
readdir rework in vfs.git, I rediffed this series.

Note: I belive this series is fine in any case, but this is also
preparation for while_each_thread() fixes.

Oleg.

 fs/proc/base.c |   69 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 33 deletions(-)

