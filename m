Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbaHZNMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:12:10 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42295 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaHZNME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:12:04 -0400
Message-ID: <53FC87A0.4000507@gmail.com>
Date: Tue, 26 Aug 2014 14:12:00 +0100
From: Iain Paton <ipaton0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <20140626151424.GT32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int> <53F11FF6.8030303@gmail.com> <CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com> <53F2E89B.80009@gmail.com> <53F5BE3D.5070209@gmail.com>
In-Reply-To: <53F5BE3D.5070209@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/14 10:39, Iain Paton wrote:
> On 19/08/14 07:03, Iain Paton wrote:
>> On 17/08/14 22:46, Fabio Estevam wrote:
>>> Iain,
>>>
>>> On Sun, Aug 17, 2014 at 6:34 PM, Iain Paton <ipaton0@gmail.com> wrote:
>>>> On 15/08/14 06:42, Mattis Lorentzon wrote:
>>>>
>>>>> We mostly run SSH with benchmarks using NFS, it can probably be
>>>>> triggered by using only SSH with the following loop:
>>>>>
>>>>> # while : ; do ssh arm-card date; done
>>>>
>>>> Mattis,
>>>>
>>>> What sort of time does it take for you to see a problem?
>>>>
>>>> I've been running the above for nearly two days on 3.16.0 on a board
>>>> with fec interrupts routed through gpio_6 and haven't seen a hint of
>>>> a problem.
>>>
>>> Thanks for testing.
>>>
>>> Which mx6 board have you used on this test?
>>
>> It's currently pointed at a RIoTboard (atheros phy) but I'm happy to 
>> try it against both a Sabre-Lite and a Wandboard B1, all running the 
>> same kernel binary, as well. 
>>
>> I'm interested enough in why different people get different results 
>> with this that I'll put some time towards testing to try to help 
>> narrow down the cause.
>>
> 
> two and a half days of running this against both a sabre-lite and a 
> wandboard quad B1 and I still have no reason to think there's any 
> sort of a problem.
> 
> Up to now, my testing has been done with my own config, I'll now
> repeat the whole thing using the config Mattis posted to see if 
> I can reproduce it that way.
> 
> Suggestions on a better / easier / quicker way to reproduce it are 
> welcome.
> 

So I wasn't able to use Mattis exact configuration as I couldn't 
get it to boot properly on anything. 

I made changes enough to enable mmc/sata and to disable the 
compiled in kernel command line and appended devicetree and initrd.
Even then it still won't boot on my WBQUAD. 
It is running on Sabre-Lite and RIoTboard though, so useful enough 
to test against the SL in a similar manner to Mattis tests with SL.

I've had the test running against both for approx one day and again 
no sign of any problems. I'm happy to leave this running, but at 
this stage I'm not expecting I'll see any problems even if I leave 
it running for a week.


