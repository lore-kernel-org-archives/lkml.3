Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3KHPzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab3KHPzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:55:49 -0500
Date: Fri, 8 Nov 2013 16:57:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes: Fix the wrong usage of current->utask in
	uprobe_copy_process()
Message-ID: <20131108155714.GA26611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I am stupid. aa59c53fd459 "uprobes: Change uprobe_copy_process()
to dup xol_area" needs the trivial fix, see 1/1. Sorry.

Perhaps I should add this patch to my tree and ask you to pull
this one-liner? Probably I can also add another "uprobes: Fix
the memory out of bound overwrite in copy_insn()" fix I sent
yesterday...

Oleg.

