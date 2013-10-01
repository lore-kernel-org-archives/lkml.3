Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JALRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:17:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:65084 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3JALRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:17:46 -0400
Date: Tue, 1 Oct 2013 13:17:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        jacob.w.shin@gmail.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tgl@domain.invalid>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
Subject: Re: [PATCH V4 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
 Extensions
Message-ID: <20131001111733.GC24825@localhost.localdomain>
References: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
 <20130428163127.GA25477@redhat.com>
 <20130429111248.GA12816@gmail.com>
 <20130429123051.GA15502@redhat.com>
 <5249862B.90604@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249862B.90604@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 09:09:47AM -0500, Suravee Suthikulpanit wrote:
> On 4/29/2013 7:30 AM, Oleg Nesterov wrote:
> >On 04/29, Ingo Molnar wrote:
> >>* Oleg Nesterov <oleg@redhat.com> wrote:
> >>>Obviously I can't ack the changes in this area, but to me the whole
> >>>series looks fine.
> >>Thanks Oleg - can I add your Reviewed-by tags?
> >Yes, sure, thanks,
> >
> >Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> >
> Hi All,
> 
> I am following up with the status of this patch as I have not seen
> it merge upstream yet.
> I was working with Jacob, and I can help following up with any
> pending issues.

Hi Suravee,

I think the best would be to rebase this patchset against the latest
version of perf:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
	perf/core

And repost it, so we can comment on a fresh and testable basis.

Thanks!
