Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3FFQqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:46:22 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:39789 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751353Ab3FFQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:46:20 -0400
Message-ID: <51B0BCD9.6030308@semaphore.gr>
Date: Thu, 06 Jun 2013 19:46:17 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic> <51AF71B6.6030408@semaphore.gr> <105446113.ZumbZWCbSi@vostro.rjw.lan> <20130606100138.GC21181@pd.tnic> <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com> <20130606121012.GD21181@pd.tnic>
In-Reply-To: <20130606121012.GD21181@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 03:10 PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 03:40:13PM +0530, Viresh Kumar wrote:
>> his patch will give significant improvement both power & performance wise.
> 
> Yes, and I'd like to see the paperwork on that. Numbers, and on a couple
> of platforms/vendors if possible, please.
> 
> Thanks.
> 

On 06/06/2013 04:15 PM, Borislav Petkov wrote:> Please do not top-post.
> 
> On Thu, Jun 06, 2013 at 03:54:20PM +0300, Stratos Karafotis wrote:
>> I will try to provide the requested info (although, I'm not sure how
>> to measure total energy :) )
> 
> tools/power/x86/turbostat looks like a good tool. It can show, a.o.,
> power consumption in Watts on modern Intels and other interesting stuff.
> 
> HTH.
> 

Apologies for top-posting. I was able to send email only from my phone.

Thanks for you hint about turbostat.

As you most probably understood, I'm individual amateur kernel developer.
I could provide some numbers from x86 architecture as Rafael suggested.
But unfortunately, I don't have access to more sources/infrastructure.
So, I will not be able to provide numbers from different platform(s).

I've already provided some benchmarks from x86 (3.10-rc3) and also
tested the patch in 3.4.47 kernel (ARM, Nexus 4 phone, ~1000 installations)
and in 3.0.80 kernel (ARM, Samsung Galaxy S phone, ~1500 installations).

Kindly let me know if "couple of platforms/vendors" is a show stopper
for this patch series. If yes, please ignore this patch and accept
my apologies for wasting your time. I am just trying to contribute
on this project (I believe there is space here for amateur developers).

Many thanks to Rafael who helped me and guide me.
Thanks to Viresh for his helpful comments and his acknowledgment for
the patch.

Best Regards,
Stratos
