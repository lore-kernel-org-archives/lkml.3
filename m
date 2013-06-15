Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3FORvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab3FORvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:51:11 -0400
Date: Sat, 15 Jun 2013 19:46:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/3] (Was: fput: task_work_add() can fail if the caller
	has passed exit_task_work())
Message-ID: <20130615174657.GA15550@redhat.com>
References: <20130614190915.GA8226@redhat.com> <20130614190947.GA8259@redhat.com> <20130614145831.c65ad42447637e3ad33eb79d@linux-foundation.org> <20130615172959.GA14656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615172959.GA14656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, forgot to mention...

On 06/15, Oleg Nesterov wrote:
>
> > OT: I don't think that schedule_work() needs to be inside the locked
> > region.  Scalability improvements beckon!
>
> Yeees, I thought about this too.
>
> Performance-wise this can't really help, this case is unlikely. But
> I think this change makes this code a bit simpler, so please see 1/3.

This is on top of
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch

it textually depends on the comment block in fput() added by that patch.

Oleg.

