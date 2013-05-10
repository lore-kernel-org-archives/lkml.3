Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3EJA25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:28:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57118 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab3EJA24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:28:56 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-5f-518c3f450951
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, fweisbec@gmail.com, peterz@infradead.org,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
	<1368073909-8825-11-git-send-email-dsahern@gmail.com>
	<20130509085137.GA8813@gmail.com> <518BAA92.2030101@gmail.com>
Date: Fri, 10 May 2013 09:28:53 +0900
In-Reply-To: <518BAA92.2030101@gmail.com> (David Ahern's message of "Thu, 09
	May 2013 07:54:26 -0600")
Message-ID: <87k3n77k56.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 09 May 2013 07:54:26 -0600, David Ahern wrote:
> On 5/9/13 2:51 AM, Ingo Molnar wrote:
>> 2)
>>
>> Another suggestion: it would be nice to allow a "--repeat <n>" option as
>> well, for a limited number of iterations - similar to what the 'top' tool
>> allows:
>>
>>    top -b -d <delay> -n <iterations>
>>
>> --repeat 0 means infinite repeats, --repeat 1 means a single step.
>
> Missed that option in perf-top. Let me take a look at it.

What Ingo said was plain "top" command, not the perf-top.

Thanks,
Namhyung
