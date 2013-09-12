Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3ILIoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:44:24 -0400
Received: from sub0000499296.hmk-temp.com ([153.122.6.145]:51585 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914Ab3ILIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:44:21 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 04:44:21 EDT
Date: Thu, 12 Sep 2013 17:35:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v2 17/25] smp, sh: kill SMP single function call
 interrupt
Message-ID: <20130912083514.GA13647@linux-sh.org>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
 <1378915649-16395-18-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378915649-16395-18-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:07:21AM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
