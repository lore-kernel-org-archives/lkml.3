Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3INQ7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:59:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48443 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3INQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:59:54 -0400
Message-ID: <523495EA.5090708@oracle.com>
Date: Sat, 14 Sep 2013 12:59:22 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com> <20130626122408.GJ28407@twins.programming.kicks-ass.net> <20130626155325.GB7399@gmail.com> <51CB4328.7010006@oracle.com> <20130627090722.GC4398@gmail.com> <51CC4461.50207@oracle.com> <51DA127E.3040706@oracle.com> <20130708083914.GB3948@gmail.com> <5231FCA1.4090803@oracle.com> <20130912180120.GB32511@gmail.com>
In-Reply-To: <20130912180120.GB32511@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 02:01 PM, Ingo Molnar wrote:
>> On 07/08/2013 04:39 AM, Ingo Molnar wrote:
>>> PeterZ is in favor as well so I'll apply them after the merge window, for
>>> v3.12.
>>
>> Hi Ingo,
>>
>> Do you intend to send liblockdep in this merge window as planned?
>
> If Peter agrees with them and picks them up then the next merge window
> would be fine I guess.

I thought that Peter acked it, and the plan was to push it through the locking
tree for 3.12?


Thanks,
Sasha

