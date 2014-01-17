Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaAQDPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:15:37 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53192 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaAQDPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:15:35 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52D8A057.4080202@roeck-us.net>
Date: Thu, 16 Jan 2014 19:15:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kevin Hao <haokexin@gmail.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Kernel stack overflows due to  "powerpc: Remove ksp_limit on
 ppc64" with v3.13-rc8 on ppc32 (P2020)
References: <20140116180532.GA1616@roeck-us.net>	 <20140117022005.GA29880@pek-khao-d1.corp.ad.wrs.com> <1389927490.7406.10.camel@pasglop>
In-Reply-To: <1389927490.7406.10.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 06:58 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2014-01-17 at 10:20 +0800, Kevin Hao wrote:
>> On Thu, Jan 16, 2014 at 10:05:32AM -0800, Guenter Roeck wrote:
>>> Hi all,
>>>
>>> I am getting kernel stack overflows with v3.13-rc8 on a system with P2020 CPU.
>>> The kernel is patched for the target, but I don't think that is related.
>>> Stack overflows are in different areas, but always in calls from __do_softirq.
>>>
>>> Crashes happen reliably either during boot or if I put any kind of load
>>> onto the system.
>>
>> How about the following fix:
>
> Wow. I've been staring at that code for 15mn this morning and didn't
> spot it ! Nice catch :-)
>
Yes, great catch! That fixes the problem.

Tested-by: Guenter Roeck <linux@roeck-us.net>

I assume you or Kevin will take it from there ?

Thanks,
Guenter

