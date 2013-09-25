Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3IYLeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:34:16 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:63755 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYLeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:34:15 -0400
Message-ID: <5242C99D.2010401@synopsys.com>
Date: Wed, 25 Sep 2013 17:01:41 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Shaohua Li <shli@kernel.org>
CC: Jiang Liu <jiang.liu@huawei.com>, Ingo Molnar <mingo@elte.hu>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Jiri Kosina" <trivial@kernel.org>, Wang YanQing <udknight@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>
Subject: Re: [RFC PATCH v2 03/25] smp, ARC: kill SMP single function call
 interrupt
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com> <1378915649-16395-4-git-send-email-liuj97@gmail.com>
In-Reply-To: <1378915649-16395-4-git-send-email-liuj97@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 09:37 PM, Jiang Liu wrote:
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

Verified that it works for ARC too.

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
