Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161436AbaDPOVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:21:44 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:53533 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaDPOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140416121734.GC19671@lee--X1>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
	<20140416102846.GL4754@lee--X1>
	<1397645078.6147.11.camel@AMDC1943>
	<534E60C6.4080005@samsung.com>
	<1397646165.6147.16.camel@AMDC1943>
	<534E6B52.9080706@samsung.com>
	<20140416121734.GC19671@lee--X1>
Date: Wed, 16 Apr 2014 23:21:39 +0900
Message-ID: <CAGTfZH2MeTtgFwQE_qz1dpJPLxD7D8h-KZmSrFEk12xydJw9OQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 9:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> >>>>> This is first part of fifth version of patchset adding support for
>> >>>>> MAX77836 device to the max14577 driver.
>> >>>>>
>> >>>>> I decided to split the patchset into smaller parts. I hope this would
>> >>>>> help in getting necessary review/acks from maintainers.
>> >>>>>
>> >>>>> The first part introduces changes in max14577 driver and adds support
>> >>>>> for MAX77836 in MFD, extcon and regulator drivers. Most of these
>> >>>>> patches already have required acks from maintainers.
>> >>>>> Full v4 patchset can be found here:
>> >>>>> http://thread.gmane.org/gmane.linux.kernel/1654267
>> >>>>
>> >>>> So what's the plan for this driver now? What's missing? Do you have
>> >>>> all the Acks you need? If so, I'm happy to apply this patch-set and
>> >>>> supply a pull-request to the other maintainers.
>> >>>
>> >>> Next patches (part 2):
>> >>> 1. charger: max14577: Add support for MAX77836 charger
>> >>> 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
>> >>> 3. regulator/mfd: max14577: Export symbols for calculating charger
>> >>>    current
>> >>> 4. charger: max14577: Configure battery-dependent settings from DTS
>> >>> 5. Documentation: mfd: max14577: Add device tree bindings document
>> >>> 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
>> >>>
>> >>> They are quite independent from each other so I think it would be the
>> >>> best if you could prepare an immutable branch with first part of
>> >>> patches.
>> >>
>> >> I have to modify all extcon device drivers for some reason,
>> >> If your patchset including extcon patch apply other git repository,
>> >> this patchset may have potential merge conflict.
>> >>
>> >> If you possible, following patchset would divide two patchset for each mfd/extcon
>> >> to remove potential merge conflict in 3.15 merge window.
>> >> - [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
>> >
>> > I think we can resolve this after preparing by Lee the immutable branch
>> > with this patches. You could pull it so your changes to extcon-max14577
>> > would be on newest version.
>>
>> I'm reluctant for your suggestion.
>
> Do you know what the suggestion is?
>
>> IMO, If Lee agree, I'd like to apply this patchset on extcon git
>> after getting ack for all patchset from maintainer.
>
> This won't work. It _will_ cause conflicts when Extcon and MFD are
> merged. The only way to solve this is to create an immutable branch.

OK,
If you make some branch for this patchset, I'll pull it on extcon branch.
