Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3FFRcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:32:20 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:40050 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741Ab3FFRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:32:17 -0400
Message-ID: <51B0C79F.6000704@semaphore.gr>
Date: Thu, 06 Jun 2013 20:32:15 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic> <51AF71B6.6030408@semaphore.gr> <105446113.ZumbZWCbSi@vostro.rjw.lan> <20130606100138.GC21181@pd.tnic> <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com> <20130606121012.GD21181@pd.tnic> <51B0BCD9.6030308@semaphore.gr> <20130606171152.GF21181@pd.tnic>
In-Reply-To: <20130606171152.GF21181@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:11 PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 07:46:17PM +0300, Stratos Karafotis wrote:
>> Apologies for top-posting. I was able to send email only from my phone.
>>
>> Thanks for you hint about turbostat.
>>
>> As you most probably understood, I'm individual amateur kernel developer.
>> I could provide some numbers from x86 architecture as Rafael suggested.
>> But unfortunately, I don't have access to more sources/infrastructure.
>> So, I will not be able to provide numbers from different platform(s).
>>
>> I've already provided some benchmarks from x86 (3.10-rc3) and also
>> tested the patch in 3.4.47 kernel (ARM, Nexus 4 phone, ~1000 installations)
>> and in 3.0.80 kernel (ARM, Samsung Galaxy S phone, ~1500 installations).
>>
>> Kindly let me know if "couple of platforms/vendors" is a show stopper
>> for this patch series. If yes, please ignore this patch and accept
>> my apologies for wasting your time. I am just trying to contribute
>> on this project (I believe there is space here for amateur developers).
>
> I'm in no way discouraging you in contributing to the kernel - on the
> opposite: you should continue doing that.

I will try! :)

> I'm just trying to make sure that a change like that doesn't hurt
> existing systems, thus the request to test on a couple of platforms. If
> you don't have other platforms, that's fine, we'll find them somewhere. :-)
>
> I'm hoping you can understand my aspect too, though - how would you feel
> if a patch shows improvement on my box but slows down yours - you won't
> be very happy with it, right? That's why we generally want to test such
> power/performance tweaks on a wider range of machines.

I'm totally understand your aspect and I think you are absolutely
right. I just wanted to declare that I am not able to provide numbers
for other platforms due to lack of hardware.

> But you said you have a i7-3770 CPU on which, I think, turbostat should
> be able to show you how the power consumption looks like.
>
> And if so, you could measure that consumption once with, and once
> without your patch. This will give us initial numbers, at least.
>
> How does that sound?
>

That sounds perfect! I will provide numbers for i7 soon.

Thanks for your comments!
Stratos

