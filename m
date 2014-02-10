Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBJLKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:10:04 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39417 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBJLJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140210110723.GV25314@e106331-lin.cambridge.arm.com>
References: <1383828154-428-1-git-send-email-ch.naveen@samsung.com>
 <20140210103354.GT25314@e106331-lin.cambridge.arm.com> <CAHfPSqANMKSW=dFKUXXM1pXAr3+rmFz8v3rpksbf4Bzc+XSNOw@mail.gmail.com>
 <20140210110723.GV25314@e106331-lin.cambridge.arm.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Mon, 10 Feb 2014 16:39:39 +0530
Message-ID: <CAHfPSqCMvygUwa3o-qeuf-Yxcdzmbq_FgS6q5MJtmeeKFHo3Ng@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: handle gate clock for misplaced TRIMINFO register
To: Mark Rutland <mark.rutland@arm.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10 February 2014 16:37, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Feb 10, 2014 at 10:50:01AM +0000, Naveen Krishna Ch wrote:
>> Hello Mark,
>>
>> On 10 February 2014 16:03, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Thu, Nov 07, 2013 at 12:42:34PM +0000, Naveen Krishna Chatradhi wrote:
>> >> On Exynos5420 the TMU(4) for GPU has a seperate clock enable bit from
>> >> the other TMU channels(0 ~ 3). Hence, accessing TRIMINFO for base_second
>> >> should be acompanied by enabling the respective clock.
>> >>
>> >> This patch which allow for a "clk_sec" clock to be specified in the
>> >> device-tree which will be ungated when accessing the TRIMINFO register.
>> >
>> > Missing binding document update? Or was "clk_sec" originally in the
>> > binding but unused?
>> >
>> > The code seems to expect "tmu_apbif_sec" as the clock name in the DT,
>> > but this isn't mentioned in the commit message.
>> >
>> > I grepped Documentation/devicetree in mainline, but found no reference
>> > of either.
>> >
>> > Thanks,
>> > Mark.
>> This CL is to be abandoned.
>
> Ok.
>
>>
>> As mentioned in the previous replies to this patch.
>> The changes in this patched were merged with
>> http://www.spinics.net/lists/devicetree/msg15165.html
>>
>> The latest patch set can be found at.
>> 1. http://www.spinics.net/lists/devicetree/msg15163.html
>> 2. http://www.spinics.net/lists/devicetree/msg15164.html
>> 3. http://www.spinics.net/lists/devicetree/msg15165.html
>> 4. http://www.spinics.net/lists/devicetree/msg15165.html
>
> I responded here because of your ping message on 2014-02-07. The latest
> patches seem to have been posted before that. Was the ping misplaced or
> have I misunderstood?
It was my bad, I replied to the patches in that series and i myself forgot that
it was abandoned patch. Sorry.
>
> Thanks,
> Mark



-- 
Shine bright,
(: Nav :)
