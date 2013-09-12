Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3ILNlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:41:05 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64047 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3ILNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:41:02 -0400
Date: Thu, 12 Sep 2013 15:40:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>
Subject: Re: [PATCH 14/16] perf kvm: reuse some code of
 perf_kvm__timerfd_create()
Message-ID: <20130912134058.GF23826@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
 <1369527896-3650-15-git-send-email-dsahern@gmail.com>
 <20130912130849.GA23826@gmail.com>
 <5231C2EF.8080200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5231C2EF.8080200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/12/13 6:08 AM, Ingo Molnar wrote:
> >
> >btw., I tried to build perf on a really old distro that has no timerfd.h,
> >and got:
> 
> Right. I hit that last week or so with RHEL5 as a build server.
> 
> timerfd was introduced before perf so any system with perf capability 
> will also have timerfd. So the problem is strictly building perf on an 
> older system. [...]

I'm booting new kernels on an old system and I'm building it there.

So it's new kernel, new perf source and binary, old userspace.

Thanks,

	Ingo
