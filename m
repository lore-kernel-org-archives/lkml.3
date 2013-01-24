Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3AXRYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:24:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3AXRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:24:50 -0500
Date: Thu, 24 Jan 2013 18:23:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: pre-filtering
Message-ID: <20130124172340.GA15868@redhat.com>
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com> <510169EA.3070506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510169EA.3070506@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24, Josh Stone wrote:
>
> On 01/24/2013 07:40 AM, Oleg Nesterov wrote:
> > I'll try to implement the pid-base filtering at least for
> > tracing/uprobe_events, but this needs a time. Not only I am not familiar
> > with this code, I am not sure how this interface should actually look.
> > And I agree, perf should be able to use it somehow, perhaps at least
> > to allow to probe a single task/mm.
>
> Even without changing perf's interface, it already has constraints for
> its child processes (versus --all-cpus) or for specific pid/tid/uid.
> Pre-filtering could help enforce and optimize those constraints.

This is what I meant. The question is how can I do this.

Oleg.

