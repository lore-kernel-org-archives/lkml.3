Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3FLA2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:28:22 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50189 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3FLA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:28:20 -0400
Message-ID: <51B7C09D.9020402@candelatech.com>
Date: Tue, 11 Jun 2013 17:28:13 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: kmemleak reports in kernel 3.9.5+
References: <51B61982.2050903@candelatech.com> <CAHkRjk5SDCbqr0Br24YQuHr=j7DmnpYk9CShrz1qiuYff7+qAw@mail.gmail.com> <51B78009.2060808@candelatech.com>
In-Reply-To: <51B78009.2060808@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:52 PM, Ben Greear wrote:
> On 06/10/2013 03:32 PM, Catalin Marinas wrote:
>> On 10 June 2013 19:22, Ben Greear <greearb@candelatech.com> wrote:
>>> We had a system go OOM while doing lots of wireless
>>> stations.  (System had 8GB of RAM, so I suspect a leak).
>>>
>>> I enabled kmemleak in a 3.9.5 (plus some local patches) and
>>> I see the entries below.  Any idea if these are real or not?

Most of this went away when I disabled SLUB debugging and other
kernel hacking options.  The wifi cfg80211_inform_bss_frame
remains, however.  I'll go dig some more on that tomorrow...didn't
see anything obvious at first glance.

But, perhaps there could be some improvements to
kmemleak to make it deal better with the various kernel
debugging features?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

