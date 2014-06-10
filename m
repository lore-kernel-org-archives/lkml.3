Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbaFJDrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:47:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1524 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933775AbaFJDrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:47:22 -0400
X-IronPort-AV: E=Sophos;i="4.98,1006,1392134400"; 
   d="scan'208";a="31687974"
Message-ID: <539680E4.1090303@cn.fujitsu.com>
Date: Tue, 10 Jun 2014 11:52:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 1/7] rtmutex: Deobfuscate chain walk
References: <20140609201118.387571774@linutronix.de>	<20140609202335.980283946@linutronix.de> <20140609165943.09935fb8@gandalf.local.home>
In-Reply-To: <20140609165943.09935fb8@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 04:59 AM, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:06 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> There is no point to keep the task ref across the check for lock
>> owner. Drop the ref before that, so the protection context is clear.
>>
>> Found while documenting the chain walk.
> 
> This looks fine, I just hate the subject. I don't see how it is
> 'deobfuscating" the chain walk. How about:
> 
> rtmutex: No need to keep task ref when checking lock ownership
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks,
Lai
