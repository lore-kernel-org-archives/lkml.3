Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaA1Lsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:48:53 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51560 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaA1Lsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:48:32 -0500
Date: Tue, 28 Jan 2014 12:48:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, davej@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com,
        Andrew Morton <akpm@linux-foundation.org>, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] numa, mem-hotplug: Initialize numa_kernel_nodes in
 numa_clear_kernel_node_hotplug().
Message-ID: <20140128114826.GA26103@gmail.com>
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com>
 <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401280109360.4244@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401280109360.4244@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Tue, 28 Jan 2014, Tang Chen wrote:
> 
> > On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
> > was not initialized. So we need to initialize it.
> > 
> > Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> > Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Reported-by: David Rientjes <rientjes@google.com>

Agreed. Tang Chen, please also spell it out in the changelog:

   David Rientjes reported a boot crash, caused by
   commit XYZ ("foo: bar").

I find it somewhat annoying that you found time to credit a corporate 
collegue with a Tested-by tag, who didn't even reply to the whole 
thread to indicate his testing efforts, but you didn't find the time 
to credit the original reporter of the bug who also reviewed your 
patches ...

Thanks,

	Ingo
