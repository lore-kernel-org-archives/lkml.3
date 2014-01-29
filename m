Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaA2HT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:19:58 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60181 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaA2HT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:19:56 -0500
Date: Wed, 29 Jan 2014 08:19:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Andrew Morton <akpm@linux-foundation.org>, zhangyanfei@cn.fujitsu.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] numa, mem-hotplug: Initialize numa_kernel_nodes in
 numa_clear_kernel_node_hotplug().
Message-ID: <20140129071953.GB30643@gmail.com>
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
 <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401280109360.4244@chino.kir.corp.google.com>
 <20140128114826.GA26103@gmail.com>
 <52E85A3B.9050703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E85A3B.9050703@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:

> Hi Ingo,
> On 01/28/2014 07:48 PM, Ingo Molnar wrote:
> 
> > 
> > * David Rientjes <rientjes@google.com> wrote:
> > 
> >> On Tue, 28 Jan 2014, Tang Chen wrote:
> >>
> >>> On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
> >>> was not initialized. So we need to initialize it.
> >>>
> >>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> >>> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >>
> >> Reported-by: David Rientjes <rientjes@google.com>
> > 
> > Agreed. Tang Chen, please also spell it out in the changelog:
> > 
> >    David Rientjes reported a boot crash, caused by
> >    commit XYZ ("foo: bar").
> > 
> > I find it somewhat annoying that you found time to credit a corporate 
> > collegue with a Tested-by tag, who didn't even reply to the whole 
> > thread to indicate his testing efforts,
> 
> Sorry for missing to indicate the test result, because I am really 
> busy with some thorny issues. If Tang did not remind me, maybe I'll 
> miss the whole thread. But I think the "Tested-by:" is the best 
> confirmation of the testing efforts, it indicates that the guy has 
> nearly completely tested the patch on his environment.

Thanks for the effort!

	Ingo
