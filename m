Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3AOI0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:26:21 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53094 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3AOI0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:26:20 -0500
Message-ID: <50F5129C.5030906@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 16:26:04 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F4C8AB.6050902@linux.vnet.ibm.com> <1358225532.25910.37.camel@marge.simpson.net>
In-Reply-To: <1358225532.25910.37.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011508-5490-0000-0000-000002CF1F70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 12:52 PM, Mike Galbraith wrote:
> On Tue, 2013-01-15 at 11:10 +0800, Michael Wang wrote: 
>> hanks for the testing, could you please tell me which benchmark
>> generate these results?
> 
> aim7, using the compute workfile, and a datapoints file containing
> $Tasks.  multitask -nl -f will prompt for the datapoints file.  You'll
> have to bump /proc/sys/kernel/sem if it's left at default by your
> distro.  If you want, I can send you a tarball offline.
> 
>> I will try to re-base the patch into 3.8-rc3 with consideration of NUMA
>> domain, I suppose it could fix the below BUG and provide a better results.
> 
> I don't _think_ you'll fix the sweet spot without setting knobs such
> that last_buddy can do its thing, but go for it ;-)

Hmm... I'm a little confusing, let's discuss on the next version if
issues are still there :)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

