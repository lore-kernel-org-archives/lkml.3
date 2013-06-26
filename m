Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3FZTi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:38:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31794 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:38:57 -0400
Message-ID: <51CB4328.7010006@oracle.com>
Date: Wed, 26 Jun 2013 15:38:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com> <20130626122408.GJ28407@twins.programming.kicks-ass.net> <20130626155325.GB7399@gmail.com>
In-Reply-To: <20130626155325.GB7399@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 11:53 AM, Ingo Molnar wrote:
>> Ingo, I don't think I see anything holding this back; however I remember
>> >reading some email about people not liking stuff like this living in the
>> >tools/ directory or such.
>> >
>> >Will you pick this up?
> So I'd really be interested in how interesting/useful this is to userspace
> developers? Does it work for something complex as Firefox, or Apache, to
> the extent they make use of these locking APIs?

So far I've tested it on Firefox, Apache, QEMU, LKVM, GCC and random smallish
programs. I haven't really done full testing for each of those, but just made
sure that liblockdep behaves as it supposed to. I'm guessing that with further
work it will dig up actual issues.


Thanks,
Sasha
