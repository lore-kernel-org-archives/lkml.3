Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3JXKkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:40:15 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:62568 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab3JXKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <20131023235448.4de21b8d.m.chehab@samsung.com>
References: <1382534520-15688-1-git-send-email-dianders@chromium.org>
	<52680380.7020204@gmail.com>
	<20131023235448.4de21b8d.m.chehab@samsung.com>
Date: Thu, 24 Oct 2013 05:40:12 -0500
Message-ID: <CAL_JsqJgtr_Z9H9Z3OJGnbD9asqYKdeziFKP--VRxh=7Qi3bVQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Don't send to devicetree list for "arch/*/boot/dts"
From: Rob Herring <robherring2@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 5:54 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Wed, 23 Oct 2013 12:12:32 -0500
> Rob Herring <robherring2@gmail.com> escreveu:
>
>> On 10/23/2013 08:22 AM, Doug Anderson wrote:
>> > As discussed in the ARM kernel summit, people on the devicetree list
>> > would no longer like to receive emails about all dts changes.  Remove
>> > from MAINTAINERS.
>>
>> We need to make sure platform maintainers are copied though. That may be
>> hard since we don't have standard layout/naming of dts files.
>>
>> We might also want to drop these:
>> K:      of_get_property
>> K:      of_match_table
>>
>> They are at least on the wrong maintainer list now as they should be
>> associated with the binding maintainers and not DT core code if we do
>> keep them.
>>
>> Also based on the discussion, we need to add
>> Documentation/devicetree/bindings/* to appropriate subsystem
>> maintainers, but that should probably wait until after Friday at least.
>
> /me is confused. What's the procedure for the DT patches for the devices
> supported by the subsystem I maintain, e. g. patches for
> /drivers/media/platform?
>
> Should I just apply them, if I think that it is needed by the hardware?
> Are there any criteria to be followed? If so, what criteria?
>
> /me hopes that all those questions will be discussed/answered at KS on
> Friday's discussions ;)

Yes, it should all become clear at the DT slot on Fri.

> In any case, my suggestion is that this patch should be a way more verbose,
> and should come together with a patch adding something at Documentation
> (SubmittingPatches, or maybe SubmitingDTPatches) in order to be sure that
> both developers and subsystem maintainers will do the right thing.

A binding howto/best practices doc is planned which should help in this area.

Rob
