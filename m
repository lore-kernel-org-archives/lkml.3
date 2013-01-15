Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3AOCdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:33:55 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51372 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3AOCdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:33:54 -0500
Message-ID: <50F4C009.5010007@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 10:33:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/2] sched: simplify select_task_rq_fair() with schedule
 balance map
References: <50EFCA29.8020801@linux.vnet.ibm.com> <50EFCAD9.5020402@linux.vnet.ibm.com> <87hamknp8i.fsf@sejong.aot.lge.com>
In-Reply-To: <87hamknp8i.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011502-8256-0000-0000-000005D3206E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 04:27 PM, Namhyung Kim wrote:
> On Fri, 11 Jan 2013 16:18:33 +0800, Michael Wang wrote:
>> +next_sd:
>> +		if (!sd->level)
>> +			break;
>> +
>> +		sbm = cpu_rq(cpu)->sbm;
>> +		if (!sbm)
>> +			break;
>> +
>> +		sd = sbm->sd[type][sd->level - 1];
>> +	};
> 
> An unnessary semicolone here.

Thanks for the notify, will correct it.

Regards,
Michael Wang

> 
> Thanks,
> Namhyung
> 

