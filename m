Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3KVRxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:53:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3KVRxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:53:13 -0500
Date: Fri, 22 Nov 2013 18:54:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] in_exec/etc cleanups
Message-ID: <20131122175424.GA31432@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Initially I was going to make a single patch (1/4) as a preparation
for the next changes, but imho this code needs cleanups. The patches
do not depend on each other, they can be applied individually.

Oleg.

 fs/exec.c             |   53 +++++++++++++-----------------------------------
 include/linux/sched.h |    1 -
 kernel/fork.c         |    1 -
 kernel/sys.c          |    5 +--
 4 files changed, 17 insertions(+), 43 deletions(-)

