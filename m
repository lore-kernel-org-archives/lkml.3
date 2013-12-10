Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3LJOxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:53:03 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47509 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LJOxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:53:01 -0500
Date: Tue, 10 Dec 2013 15:52:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        jacob.w.shin@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131210145248.GD10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131108194122.GA14606@localhost.localdomain>
 <20131109151156.GA14249@redhat.com>
 <20131109153236.GE26079@localhost.localdomain>
 <20131109155428.GA15649@redhat.com>
 <20131111154417.GD26853@localhost.localdomain>
 <20131111175131.GA14906@redhat.com>
 <CAFTL4hwS9FHNvK8A-wqSNzzjSW2OsicxrRh=XT7nRo0=Kw1s=g@mail.gmail.com>
 <20131204135743.GB7251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204135743.GB7251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:57:43PM +0100, Oleg Nesterov wrote:
> > Ideally it would be nice if we drop bp_mask and use extended ranges
> > only when len > 8. How does that sound?
> 
> Again, iirc, this is what the code does. except (in essence) it checks
> mask != 0 instead of len > 8.
> 
> And yes, we can probably drop bp_mask (unless we are going to support
> the contiguous ranges), just I think we can do this later.

Ah wait, I understand now, this is not a user ABI, just an internal state.
So you're right after all.

It's never too late to be unconfused ;)

Ok let me dig into more details on the patchset.

Thanks.
