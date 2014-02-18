Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaBRC2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:28:22 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37441 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBRC2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:28:21 -0500
Message-ID: <5302C53E.2020404@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 10:28:14 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com> <5301C41D.5000009@linux.vnet.ibm.com> <53027A12.9090106@oracle.com>
In-Reply-To: <53027A12.9090106@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021802-5564-0000-0000-00000C10CE7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 05:07 AM, Sasha Levin wrote:
[snip]
> 
> I *think* it works. There seems to be another sched issue that causes
> lockups,
> so I can't say for certain that this one doesn't occur anymore.
> 
> I'm still working on collecting data for the other issue, I'll mail
> about it soon.

Thanks for that, looking forward the results :)

Regards,
Michael Wang

> 
> 
> Thanks,
> Sasha
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

