Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaBVBpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 20:45:16 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:43363 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaBVBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 20:45:14 -0500
Message-ID: <53080122.609@linux.vnet.ibm.com>
Date: Sat, 22 Feb 2014 09:45:06 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com>
In-Reply-To: <53078241.3060201@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022201-2674-0000-0000-00000CD753DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 12:43 AM, Sasha Levin wrote:
> On 02/19/2014 11:32 PM, Michael wang wrote:
>> On 02/20/2014 02:08 AM, Sasha Levin wrote:
>>> >Hi all,
>>> >
>>> >While fuzzing with trinity inside a KVM tools guest, running latest
>>> >-next kernel, I see to hit the following hang quite often.
>> Fix for the stuck issue around idle_balance() is now in progress, this
>> may caused be the same problem, I suggest we do some retest after these
>> patch got merged.
> 
> Could I get a link to the patch please? It's a pain testing other things
> with this issue reproducing every time.

Please take a try on the latest tip tree, patches has been merged as I
saw :)

Regards,
Michael Wang

> 
> 
> Thanks,
> Sasha
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

