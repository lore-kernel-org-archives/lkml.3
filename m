Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3KGQ0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:26:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab3KGQ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:26:32 -0500
Date: Thu, 7 Nov 2013 17:27:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107162736.GA31834@redhat.com>
References: <20131106191913.GA18661@redhat.com> <20131107075151.GB31560@gmail.com> <20131107143432.GA6240@redhat.com> <20131107151601.GA5163@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107151601.GA5163@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > and we need to cleanup copy_insn()
> > first.

Heh. I never read it carefully, I always knew it should be cleanuped.

But when I looked at it now I realized that it is very wrong, and it
is very easy to crash the kernel (fortunately only root can enable
uprobes).

So we need to fix it (and cleanup), I'll try to make the patch asap.

> > For the moment, please ignore the patch which adds the new ->ixol
> > member.
>
> I didn't actually disagree with it so I pulled it

Thanks,

> - I was just wondering
> about those cleanliness details.

And you are right, this doesn't look clean. I should have mentioned
in the changelog that we need to (at least try) to cleanup this all.

Oleg.

