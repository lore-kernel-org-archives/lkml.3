Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3AXRHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:07:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3AXRHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:07:03 -0500
Date: Thu, 24 Jan 2013 18:06:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Josh Stone <jistone@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130124170612.GA14823@redhat.com>
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com> <20130124154159.GB32071@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124154159.GB32071@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Unfortunately, currently there is no in-kernel user of
> > pre-filtering.
> >
> > I'll try to implement the pid-base filtering at least for
> > tracing/uprobe_events, but this needs a time. Not only I am
> > not familiar with this code, I am not sure how this interface
> > should actually look. And I agree, perf should be able to use
> > it somehow, perhaps at least to allow to probe a single
> > task/mm.
>
> Would be nice to get something minimal/simple going, so that it
> can be tested, etc.

Heh, I understand.

I do not see anything simple to implement... I'll try to think.
Srikar, do you have any idea?

All I can say right now: I'll send you the patches when I have them ;)
Can't promise this will be soon.

_Perhaps_, as a first step, we can simply change create_trace_uprobe()
so that it would be possible to specify list-of-pids at creation time...
Not sure this actually makes sense.

Oleg.

