Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaFJC4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:56:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:9004 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934053AbaFJC4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:56:07 -0400
X-IronPort-AV: E=Sophos;i="4.98,1006,1392134400"; 
   d="scan'208";a="31686012"
Message-ID: <539674DA.6060005@cn.fujitsu.com>
Date: Tue, 10 Jun 2014 11:00:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 0/7] rtmutex: Code clarification and optimization
References: <20140609201118.387571774@linutronix.de>	<20140609202713.32e649ea@gandalf.local.home> <20140609203522.1a339d7c@gandalf.local.home>
In-Reply-To: <20140609203522.1a339d7c@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 08:35 AM, Steven Rostedt wrote:
> On Mon, 9 Jun 2014 20:27:13 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
>> So what branch do these apply to? I tried latest Linus master and it
>> didn't apply.
> 
> OK, they seem to be on tip/locking/urgent. Not yet in mainline.


Thank you for share it, I'm trying to review the patches.

Lai

> 
> -- Steve
> .
> 

