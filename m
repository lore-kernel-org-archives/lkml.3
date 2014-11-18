Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaKRTik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:38:40 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43180 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaKRTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:38:38 -0500
Message-ID: <546BA04E.1050406@gmail.com>
Date: Tue, 18 Nov 2014 14:38:54 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/16] rcupdate: Replace smp_read_barrier_depends() with
 lockless_dereference()
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com> <1415906662-4576-9-git-send-email-bobby.prani@gmail.com> <20141118171639.GV5050@linux.vnet.ibm.com>
In-Reply-To: <20141118171639.GV5050@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/18/2014 12:16 PM, Paul E. McKenney wrote:
> On Thu, Nov 13, 2014 at 02:24:14PM -0500, Pranith Kumar wrote:
>> Recently lockless_dereference() was added which can be used in place of
>> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Queued for 3.20, thank you!  I was wondering about your removing the
> "_" from "_________p1", but see that this allowed you to avoid the
> checkpatch.pl warning.  ;-)
>
Yes, that was the easiest way I could think of to avoid the warning with adding more lines.

I will send the rest of the patches updated with comments.

Thanks,
Pranith

