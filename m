Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaA2HRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:17:38 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58543 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaA2HRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:17:37 -0500
Date: Wed, 29 Jan 2014 08:17:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: another perf_fuzzer soft lockup
Message-ID: <20140129071731.GA30643@gmail.com>
References: <alpine.DEB.2.10.1401281554010.8613@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401281554010.8613@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> After some idle time I've started running the perf_fuzzer again.
> 
> It quickly found this lockup on a core2 system running 3.13 (yes, I 
> should probably be running 3.14-git but I'd rather wait for rc1 
> first).

JFYI, if -git looks too dangerous to you (and I cannot blame you for 
that view in the middle of a merge window) then tip:master is usually 
a pretty safe substitute for testing, it's the v3.14 perf code on a 
v3.13 base.

> It looks like it's stuck in a lock in generic_exec_single() while 
> calling perf_event_task_output()?
> 
> I'll try to see if I can come up with a test case.

Thanks, those testcases are always very useful!

	Ingo
