Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3FYVUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:20:06 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38175 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3FYVUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:20:04 -0400
Message-ID: <51CA0980.8010409@gmail.com>
Date: Tue, 25 Jun 2013 15:20:00 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
References: <51CA0622.8010105@gmail.com> <20130625211713.GA18796@laptop.programming.kicks-ass.net>
In-Reply-To: <20130625211713.GA18796@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 3:17 PM, Peter Zijlstra wrote:
> On Tue, Jun 25, 2013 at 03:05:38PM -0600, David Ahern wrote:
>> Peter/Ingo:
>>
>> I can reliably cause a deadlock in the scheduler by enabling the HRTICK
>> feature. I first hit the problem with 2.6.27 but have been able to reproduce
>> it with newer kernels. I have not tried top of Linus' tree, so perhaps this
>> has been fixed in 3.10.
>
> Yeah, I know.. its been on the todo list forever but its never been
> important. Its disabled by default and all sched debug features are for
> those brave enough to keep the pieces ;-)
>

Not a whole to of pieces to keep.

What is the expectation that the feature provides? not a whole lot of 
documentation on it. I walked down the path wondering if it solved an 
odd problem we are seeing with the CFS in 2.6.27 kernel.

David
