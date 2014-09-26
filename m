Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaIZQcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:32:51 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60064 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaIZQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <541C7609.3000901@ti.com>
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
 <CAL_JsqJAtWnHKPVpDsdOOzT_X=npc3hroLNTGqULM2SJr=1OEg@mail.gmail.com>
 <53A46CB7.1030109@ti.com> <4193075.zZSpRTFEYz@wuerfel> <53A48553.2080504@ti.com>
 <CAL_JsqLYho6dRA=-ovKqF7H4EGHJcH_aN3ywd+76oXSprfTMbQ@mail.gmail.com>
 <53A73110.60405@ti.com> <541C7609.3000901@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Sep 2014 11:32:25 -0500
Message-ID: <CAL_Jsq+Lu0D3o0wrFS0tug_7oTtySaAEJCEJWBaOha4RHsoxZg@mail.gmail.com>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 1:29 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Rob,
>
>
> On 06/22/2014 10:40 PM, Santosh Shilimkar wrote:
>>
>> On Friday 20 June 2014 03:46 PM, Rob Herring wrote:
>>>
>>> On Fri, Jun 20, 2014 at 2:02 PM, Santosh Shilimkar
>>> <santosh.shilimkar@ti.com> wrote:
>>>>
>>>> On Friday 20 June 2014 02:56 PM, Arnd Bergmann wrote:
>>>>>
>>>>> On Friday 20 June 2014 13:17:43 Santosh Shilimkar wrote:
>>>>>>>>
>>>>>>>> +                       dma-coherent;
>>>>>>>> +                       dma-ranges;
>>>>>>>> +
>>>>>>>> +                       dwc3@2690000 {
>>>>>>>> +                               compatible = "synopsys,dwc3";
>>>>>>>> +                               [...]
>>>>>>>> +                       };
>>>>>>>
>>>>>>>
>>>>>>> This example is a bit strange. I don't understand the relationship
>>>>>>> between keystone-dwc3 and synopsys,dwc3, nor do I want to. I'd prefer
>>>>>>> to see a simple example here.
>>>>>
>>>>>
>>>>>
>>>>>>> dma-ranges is a property of the parent which you show, but
>>>>>>> dma-coherent originally was a property of the bus master itself.
>>>>>>> While
>>>>>>> we need to support that, are we changing that? We need to be clear on
>>>>>>> where the property belongs even if the kernel is more lax.
>>>>>>>
>>>>>> I don't think we are changing it fundamentally but may be I missing
>>>>>> your point. The dma-coherent as is now a per-device property.
>>>>>> USB is one of the bus master supports coherency and hence showed
>>>>>> up in above example.
>>>>>
>>>>>
>>>>> I think it's enough if you just drop the "synopsys,dwc3" node and the
>>>>> intermediate dma-ranges property from the example, leaving the
>>>>> dma-coherent property in the "ti,keystone-dwc3" node.
>>>>>
>>>> Thanks Arnd. That should avoid the confusion. Just to see if Rob is
>>>> fine by it, the example will look like below.
>>>
>>>
>>> Yes. Looks fine.
>>>
>> Great. Updated version 2 below.
>
>
> Seems, this patch has not been merged accidentally :(
> Is it possible for you to take it, or would you like me to re-send it?

Applied. Sorry for the delay.

Rob
