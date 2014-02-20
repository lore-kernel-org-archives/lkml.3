Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaBTQso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:48:44 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35452 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaBTQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:48:42 -0500
Message-ID: <530631E5.5050104@gmail.com>
Date: Thu, 20 Feb 2014 08:48:37 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Otto Meier <gf435@gmx.net>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [3.14-rc3] possible regression Haswell runs only at 770Mhz with
 powersave governor
References: <53061204.7080700@gmx.net> <20140220150101.GA9557@pd.tnic>
In-Reply-To: <20140220150101.GA9557@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 07:01 AM, Borislav Petkov wrote:
> Add lists to CC.
>
> On Thu, Feb 20, 2014 at 03:32:36PM +0100, Otto Meier wrote:
>> Hello,
>>
>> My System which runs with older kernels up to 3.13.3
>> fine on my i3-4330 with 3.5 Ghz and governor powersave.
>> and pstate driver.
>>
>> With kernel 3.14-rc3 and Governor powersave it runs
>> only at 770Mhz and never switches to higher Freq. on load.
>> Even compiling a kernel with make -j4   does not change freq.
>>

commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 seems to be the culprit

>> With governor performance  it switches to 3.5 Ghz and stays
>> there.
>>
>> Any Idea how to fix this?
>>

Greg KH is seeing the same thing on his Haswell system.  I am trying
to figure what went south.

https://lkml.org/lkml/2014/2/19/626


Can you send me the .config for the broken kernel also the output of gcc -v



>> Best regards
>

