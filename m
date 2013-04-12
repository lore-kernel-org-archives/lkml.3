Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3DLDRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 23:17:39 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60795 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3DLDRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 23:17:38 -0400
Message-ID: <51677CB0.606@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 11:17:04 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1365583873.30071.31.camel@laptop>
In-Reply-To: <1365583873.30071.31.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041203-8256-0000-0000-0000070A6F73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 04:51 PM, Peter Zijlstra wrote:
> On Wed, 2013-04-10 at 11:30 +0800, Michael Wang wrote:
>> | 15 GB   |      32 | 35918 |   | 37632 | +4.77% | 47923 | +33.42% |
>> 52241 | +45.45%
> 
> So I don't get this... is wake_affine() once every milisecond _that_
> expensive?
> 
> Seeing we get a 45%!! improvement out of once every 100ms that would
> mean we're like spending 1/3rd of our time in wake_affine()? that's
> preposterous. So what's happening?

Hi, Peter

I think Mike has very well explained the reason why throttle bring us
benefit and why the benefit looks so significant when interval get
higher, could you please take a look at his mail and see whether it
addressed this concern?

And thanks Mike again for the excellent analysis :)

Regards,
Michael Wang


> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

