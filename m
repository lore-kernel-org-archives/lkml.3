Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaKZRz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:55:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20745 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaKZRz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:55:26 -0500
Message-ID: <54761406.9090602@oracle.com>
Date: Wed, 26 Nov 2014 12:55:18 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
CC: mingo <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com> <CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>
In-Reply-To: <CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 12:50 PM, Andrey Ryabinin wrote:
> 2014-11-26 17:00 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
>> > Detect integer overflows using safe operations rather than relying on
>> > undefined behaviour.
>> >
> Unsigned overflow is defined.
> args->addr and args->len  both unsigned, so there is no UB here.
> 

Good point. Do you think there's an advantage in using GCC's overflow
checker in this case?


Thanks,
Sasha
