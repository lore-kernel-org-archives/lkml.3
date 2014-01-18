Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaARIpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 03:45:04 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39032 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaARIpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 03:45:01 -0500
Message-ID: <52DA3F09.5060200@gmail.com>
Date: Sat, 18 Jan 2014 09:44:57 +0100
From: Branimir Maksimovic <branimir.maksimovic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: vm commit in atop utility steadilly grows (latest mainline kernel
 from git)
References: <52D97F2D.1020500@gmail.com> <20140118003448.5b2b0e6d.akpm@linux-foundation.org>
In-Reply-To: <20140118003448.5b2b0e6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 09:34 AM, Andrew Morton wrote:
> On Fri, 17 Jan 2014 20:06:21 +0100 Branimir Maksimovic <branimir.maksimovic@gmail.com> wrote:
>
>> Yesterday, I have noticed that vmcom steadilly grows (it was 7TB before
>> I noticed). I compile kernel every day or two after git pull.
>> Rebooted and then watched atop, vmcom constantly grows.
>> Didn't notice any of running processes to allocate.
>> Booted in 3.12.8 kernel and everything is back to normal.
>> Since this is pretty noticable, I guess that this is caused by commit
>> between rc8 release and now, not sure.
>> Machine is i5 3570k, motherboard asus maximus gene v.
>>
> I expect this was fixed by
>
> commit d1969a84dd6a44d375aa82bba7d6c38713a429c3
> Author: Hugh Dickins <hughd@google.com>
> Date:   Thu Jan 16 15:26:48 2014 -0800
>
>      percpu_counter: unbreak __percpu_counter_add()
>

It is fixed. Running normal now.


