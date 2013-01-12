Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3ALQjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 11:39:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab3ALQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 11:39:12 -0500
Date: Sat, 12 Jan 2013 17:38:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josh Stone <jistone@redhat.com>, srikar@linux.vnet.ibm.com,
        mingo@kernel.org, peterz@infradead.org, anton@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add exports for module use
Message-ID: <20130112163840.GA19987@redhat.com>
References: <1357858906-9711-1-git-send-email-jistone@redhat.com> <20130111093227.GA30043@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111093227.GA30043@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Christoph Hellwig wrote:
>
> On Thu, Jan 10, 2013 at 03:01:46PM -0800, Josh Stone wrote:
> > The original pull message for uprobes (commit 654443e2) noted:
> >
> >   This tree includes uprobes support in 'perf probe' - but SystemTap
> >   (and other tools) can take advantage of user probe points as well.
> >
> > In order to actually be usable in module-based tools like SystemTap, the
> > interface needs to be exported.  This patch first adds the obvious
> > exports for uprobe_register and uprobe_unregister.  Then it also adds
> > one for task_user_regset_view, which is necessary to get the correct
> > state of userspace registers.
>
> Get systemtap into the mainline kernel tree and we can talk.

I can't understand your reply.

Looks like, you do not like the fact that uprobes can be used by the out
of tree modules. Why?

And why, say, kprobe_register() is exported then? Afaics, it does not
have any modular in-kernel user.

As for systemtap in particular. I never used it, and probably you didn't.
But it has a lot of users, and I know many people who find it very useful.

Oleg.

