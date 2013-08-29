Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3H2Orv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:47:51 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59909 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3H2Orj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:47:39 -0400
Message-ID: <521F5F07.4090609@baylibre.com>
Date: Thu, 29 Aug 2013 16:47:35 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg KH <greg@kroah.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <521CAF59.1090203@linutronix.de> <521CB046.9070408@baylibre.com> <521CB18B.4080000@linutronix.de> <521CB239.6050409@baylibre.com> <521CB403.8010307@linutronix.de> <20130827173732.GC21564@kroah.com> <20130827183732.GP3005@radagast> <20130827193021.GA30113@kroah.com> <20130827195652.GE3005@radagast> <521F1D28.7070003@baylibre.com> <20130829142302.GJ9325@radagast>
In-Reply-To: <20130829142302.GJ9325@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/2013 16:23, Felipe Balbi wrote:
> On Thu, Aug 29, 2013 at 12:06:32PM +0200, Benoit Cousson wrote:
>> Hi Felipe
>>
>> On 27/08/2013 21:56, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Tue, Aug 27, 2013 at 12:30:21PM -0700, Greg KH wrote:
>>>> On Tue, Aug 27, 2013 at 01:37:32PM -0500, Felipe Balbi wrote:
>>>>> Hi,
>>>>>
>>>>> On Tue, Aug 27, 2013 at 10:37:32AM -0700, Greg KH wrote:
>>>>>> On Tue, Aug 27, 2013 at 04:13:23PM +0200, Sebastian Andrzej Siewior wrote:
>>>>>>> On 08/27/2013 04:05 PM, Benoit Cousson wrote:
>>>>>>>> On 27/08/2013 16:02, Sebastian Andrzej Siewior wrote:
>>>>>>>>> On 08/27/2013 03:57 PM, Benoit Cousson wrote:
>>>>>>>>>> + Kevin,
>>>>>>>>>>
>>>>>>>>>> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
>>>>>>>>>>> What do we do now?
>>>>>>>>>>
>>>>>>>>>> Cannot you just merge the stable arm-soc/dt branch into your branch
>>>>>>>>>> before applying your patches?
>>>>>>>>>
>>>>>>>>> That is up to Greg. This changes sat in his usb-next tree for a while
>>>>>>>>> now. And before they hit Greg they were in Felipe's tree for a while.
>>>>>>>>>
>>>>>>>>> To be exact, last .dts change via USB was:
>>>>>>>>>
>>>>>>>>> Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>>>>>>>> AuthorDate: Thu Jun 20 12:13:04 2013 +0200
>>>>>>>>> Commit:     Felipe Balbi <balbi@ti.com>
>>>>>>>>> CommitDate: Fri Aug 9 17:40:16 2013 +0300
>>>>>>>>>
>>>>>>>>>      usb: musb dma: add cppi41 dma driver
>>>>>>>>
>>>>>>>> Mmm, if that branch is supposed to be stable, I'm not sure it will be
>>>>>>>> doable...
>>>>>>>>
>>>>>>>> Maybe we should do the other way around? And merge usb-next into
>>>>>>>> arm-soc/dt.
>>>>>>>>
>>>>>>>> Kevin, Olof?
>>>>>>>
>>>>>>> Please be aware that I have no response so far regarding [0] from Greg.
>>>>>>>
>>>>>>> [0] http://www.spinics.net/lists/linux-usb/msg92595.html
>>>>>>
>>>>>> Nor will you, given that I am not the one to take these patches, Felipe
>>>>>> is.  I noticed now that you said "please route around Felipe", but
>>>>>> sorry, no, I'm not going to do that unless there's a really good reason.
>>>>>> Felipe seems to be around at the moment, please work with him on this.
>>>>>
>>>>> If you will still take a 'part2' pull request from me, I can send you
>>>>> urgent bugfixes by friday. If I have some time left, I can even try to
>>>>> get that sorted out by tomorrow.
>>>>
>>>> For 3.12 stuff, like "fixes", sure, I can take them this week, that
>>>> should give us a week or so for linux-next testing, right?
>>>
>>> that's correct. I have most of them already queued up, let me just go
>>> over my linux-usb maildir again and make sure I got all the important
>>> stuff in.
>>>
>>> cheers, thanks for opening this 'window'.
>>
>> There are two patches in my DTS tree that conflict with the usb-next.
>>
>> I will remove that one (ARM: dts: AM33XX: don't redefine OCP bus and
>> device nodes) , as suggested by Olof, since it is the biggest source
>> of conflict from my tree.
>>
>> The second one is easily fixable, and Stephen already did it, but it
>> will be even better it you could take it in your tree.
>> This is the patch you did that I just slightly renamed (ARM: OMAP5:
>> dts: fix reg property size).
>
> I'm done with Pull requests for Greg. If the conflict is easy to solve,
> what's the problem in having the conflict to start with ?

Well, it is mainly the other one that is a pain to fix. Since I was 
about to send another pull-request, I was wondering if you'll be OK to 
take it.

Regards,
Benoit
