Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3HFRgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:36:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:53166 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3HFRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:36:32 -0400
Message-ID: <52013413.5070704@gmail.com>
Date: Tue, 06 Aug 2013 19:36:19 +0200
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Thomas Renninger <trenn@suse.de>, Hannes Reinecke <hare@suse.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ming Lei <ming.lei@canonical.com>,
        =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Julius Werner <jwerner@chromium.org>,
        Yuanhan Liu <yliu.null@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: fix some scripts/kernel-doc warnings
References: <1375467004-2623-1-git-send-email-yacine.belkadi.1@gmail.com> <20130803032908.GA10902@kroah.com> <51FEB410.6080909@gmail.com> <20130804212919.GA10623@kroah.com> <51FFF0B7.3080708@gmail.com> <20130805222829.GH20884@kroah.com>
In-Reply-To: <20130805222829.GH20884@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:28 AM, Greg Kroah-Hartman wrote:
> On Mon, Aug 05, 2013 at 08:36:39PM +0200, Yacine Belkadi wrote:
>> On 08/04/2013 11:29 PM, Greg Kroah-Hartman wrote:
>>> On Sun, Aug 04, 2013 at 10:05:36PM +0200, Yacine Belkadi wrote:
>>>> On 08/03/2013 05:29 AM, Greg Kroah-Hartman wrote:
>>>>> On Fri, Aug 02, 2013 at 08:10:04PM +0200, Yacine Belkadi wrote:
>>>>>> When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
>>>>>> following type of warnings:
>>>>>>
>>>>>> Warning(drivers/usb/core/usb.c:76): No description found for return value of
>>>>>> 'usb_find_alt_setting'
>>>>>>
>>>>>> Fix them by:
>>>>>> - adding some missing descriptions of return values
>>>>>> - using "Return" sections for those descriptions
>>>>>>
>>>>>> Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
>>>>>> ---
>>>>>>
>>>>>>  Applied to b3a3a9c441e2c8f6b6760de9331023a7906a4ac6
>>>>>
>>>>> What does this line mean?
>>>>
>>>> It's the commit on which I created and applied the patch:
>>>>
>>>> commit b3a3a9c441e2c8f6b6760de9331023a7906a4ac6
>>>> Merge: a582e5f e70e78e
>>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>>> Date:   Mon Jul 22 19:07:24 2013 -0700
>>>
>>> Odd, I've never seen anyone use that before.  It's really not needed, so
>>> you don't have to do that in the future.
>>>
>>
>> In hindsight, I should probably have used something like:
>> "Patch against commit b3a3a9c441e2c8f6b6760de9331023a7906a4ac6".
>>
>> I thought this information may prove useful in some cases, because of the
>> nature of the patch, which only modifies comments and may get out of sync
>> with the code.
>>
>> Here is an example:
>> - My local HEAD is at commit c1 when I start creating the patch.
>> - Some function f doesn't have a description for its return value. I look
>> into the code and deduce the description. So the description I add is based
>> on the code at the commit c1.
>> - Someone else submits a patch that changes the code of the function f, but
>> I don't see it.
>> - I send my patch to the maintainer.
>> - My patch may apply cleanly on top of the other patch (mine only touched
>> the comments), but the description now doesn't match the function's code,
>> which is a problem.
>>
>> I assumed that if I specify the commit on which I worked, it may help the
>> maintainer decide whether my patch got invalidated by some other patch that
>> was applied first. Continuing with the example: The maintainer sees that I
>> worked based on c1, but knows that a patch was applied in the mean time, so
>> he/she asks me to update my patch first.
>>
>> What do you think?
> 
> It does make sense, but please use terms that we can understand.  If I
> see a sha id, I have to go dig through a kernel tree to see what it
> represents, which takes time (remember, I deal with thousands of
> patches).  If you said "Patch based on 3.11-rc1" then I know exactly
> what that is, and how to handle it if there are merge errors.

Noted. Thanks!

Yacine
