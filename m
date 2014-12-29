Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaL2Mcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:32:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbaL2Mc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:32:28 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] oom and TIF_MEMDIE setting to mm-less tasks fixes
Date: Mon, 29 Dec 2014 13:32:05 +0100
Message-Id: <1419856327-673-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
could you pick up these two fixes which came out of a longer discussion
started here: http://marc.info/?l=linux-mm&m=141839249819519. The thread
became quite confusing as multiple issues were discussed there so I think
reposting them in a new thread will make more sense.

Thanks

