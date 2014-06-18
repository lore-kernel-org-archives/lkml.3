Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbaFRH4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:56:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34575 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaFRH4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:56:53 -0400
Message-ID: <53A1463A.9040401@ti.com>
Date: Wed, 18 Jun 2014 10:56:42 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>, "Menon, Nishanth" <nm@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Kevin Hilman <khilman@linaro.org>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <balbi@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH v4 3/4] ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
References: <1398274237-24510-1-git-send-email-rogerq@ti.com> <1398274559-24777-1-git-send-email-rogerq@ti.com> <alpine.DEB.2.02.1406131901340.340@utopia.booyaka.com> <alpine.DEB.2.02.1406150331530.659@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1406150331530.659@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Rajendra, Nishant and Kevin.
as you were mentioned in the discussion.

cheers,
-roger

On 06/15/2014 06:33 AM, Paul Walmsley wrote:
> On Fri, 13 Jun 2014, Paul Walmsley wrote:
> 
>> Hi Roger,
>>
>> On Wed, 23 Apr 2014, Roger Quadros wrote:
>>
>>> From: Nikhil Devshatwar <nikhil.nd@ti.com>
>>>
>>> Add hwmods for ocp2scp3 and sata modules.
>>>
>>> [Roger Q] Clean up.
>>
>> Sorry for the delay on this.  Have been corresponding with TI to figure 
>> out what to do about these DRA7xx/AM43xx patches, since I don't have 
>> boards or public documentation for these devices, so it's impossible for 
>> me to meaningfully review the patches.  Looks like boards and/or public 
>> docs won't be coming any time soon.
>>
>> So for my part, here's what I'll need to merge any hwmod patches that 
>> involve AM437x or DRA7xx:
>>
>> 1. A Reviewed-by: from one of the following folks (which should come from 
>> a different person than who is submitting the patches):
>>
>> Roger Quadros
>> Nishanth Menon
>> Rajendra Nayak
>> Kevin Hilman
>> Tony Lindgren
>>
>> 2. A Tested-by: from one of the following folks (who can be the same as 
>> the person who is the same as the person who is submitting the patches):
>>
>> Nishanth Menon
>> Rajendra Nayak
>> Kevin Hilman 
>> Tony Lindgren
>>
>> Once these are in place, I'd be happy to queue it for 3.16.
> 
> I've tried to clarify this a bit.  The update is below.
> 
> 
> - Paul
> 
> 
> 
> For boards that I don't have access to, that I don't have 
> documentation for, such as the AM43xx and DRA7xx), for me to merge or ack 
> SoC infrastructure or PM-related patches, I want to have:
> 
> 1. a Reviewed-by: from people who:
> 
> a. I think know something about SoC integration or PM in general, and 
> about OMAP-style integration specifically; and
> 
> b. who have a track record of doing strong and detailed reviews of that 
> code, or who have contributed significantly to that code in the past.
> 
> My initial list of those reviewers is listed above, and I am happy to 
> consider extending it or modifying that list.
> 
> 
> 2. confidence that the patch or series has been tested against a mainline 
> commit and isn't obviously breaking other things, like PM, and confidence 
> that it's not adding new runtime warnings.
> 
> I've listed an initial set of people above who I feel have proven track 
> records in testing who I'm happy to accept Tested-by:s without further 
> explanation.  I'm sure I've missed some folks and if anyone who should be 
> on that list is offended that I didn't mention them, please accept my 
> apologies.  For other folks, like yourself, who aren't on that list (yet), 
> please just specifically state:
> 
> a. what mainline commit they've tested the patch against,
> 
> b. what other prerequisite patches were needed for the patch to apply,
> 
> c. and a cut-and-paste of the serial console boot log from the boot 
> portion of the test.
> 
> in such a way that myself or someone else can easily doublecheck it. 
> 
> And frankly, I'll probably be happy to merge it.
> 
> After someone has done these three things a few times, and I gain 
> confidence that they're doing the right thing, I'm happy to add them to 
> my list.
> 
> The testing doesn't have to be expressed via a Tested-by: tag in cases 
> where you're testing as part of a Signed-off-by:.  Just be sure to state 
> those three things above as part of the patch or series message.  The boot 
> log can either be placed on a different page and linked to, or sent in 
> another public E-mail.
> 
> If you can get two or three people to do the above, that's great - the 
> more, the better.
> 
> ...
> 
> These two steps do not apply to boards that I have in my testbed or which 
> I have documentation for (although they would definitely be very welcome 
> in those cases too).
> 

