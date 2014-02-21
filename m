Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbaBUQon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:44:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40764 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaBUQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:44:18 -0500
Message-ID: <53078241.3060201@oracle.com>
Date: Fri, 21 Feb 2014 11:43:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com>
In-Reply-To: <5305856F.3000109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 11:32 PM, Michael wang wrote:
> On 02/20/2014 02:08 AM, Sasha Levin wrote:
>> >Hi all,
>> >
>> >While fuzzing with trinity inside a KVM tools guest, running latest
>> >-next kernel, I see to hit the following hang quite often.
> Fix for the stuck issue around idle_balance() is now in progress, this
> may caused be the same problem, I suggest we do some retest after these
> patch got merged.

Could I get a link to the patch please? It's a pain testing other things with this issue reproducing 
every time.


Thanks,
Sasha
