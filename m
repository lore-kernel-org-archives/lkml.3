Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaDRWLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:11:51 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:34635 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaDRWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:11:49 -0400
Message-ID: <5351A31E.7080109@atmel.com>
Date: Sat, 19 Apr 2014 00:11:42 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Bo Shen <voice.shen@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
CC: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <devicetree@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/8] ARM: at91: sama5d3: enable sound support
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <53518C76.2020005@atmel.com> <5351A1DE.9070801@gmail.com>
In-Reply-To: <5351A1DE.9070801@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/2014 00:06, Boris BREZILLON :
> 
> On 18/04/2014 22:35, Nicolas Ferre wrote:
>> On 17/03/2014 10:45, Bo Shen :
>>> This patch add sound support on sama5d3xek board.
>>>
>>> This patch series based on the following patch set:
>>>   clk: at91: better support for the PCKs
>>>   http://comments.gmane.org/gmane.linux.kernel/1664477
>>>
>>>
>>> Bo Shen (5):
>>>   ARM: at91: sama5d3: add DMA property for SSC devices
>>>   ARM: at91: sama5d3: disable sound by default
>>>   ARM: at91: sama5d3: correct the sound compatible string
>>>   ARM: at91: sama5d3: add the missing property
>>>   ARM: at91: sama5d3: clock for ssc from rk pin
>>>
>>> Boris BREZILLON (3):
>>>   ASoC: atmel: support CCF based clks
>>>   ASoC: atmel: document clock properties of the wm8904 driver
>>>   ARM: at91/dt: add clock properties to the wm8904 codec node
>> Hi Voice and Boris,
>>
>> For this series I am a little bit puzzled: should I take the ASoC part
>> of it? I see no acknowledgement from Mark and I also read some messages
>> still discussing about CCF and wm8904 afterwards.
>>
>> So, I take the 5 patches by Voice Shen and tell me what is the proper
>> sequence with this wm8904 work.
> 
> Bo was waiting for the "move sam9n12 SoC to the CCF" (which has been
> submitted earlier this week) series before sending a new version of his
> "wm8904: add CCF support" series.

Ok, that makes perfect sense.
So I have the whole dependency graph in mind now: we will have fun
stacking everything in the proper order ;-)

Thanks for the clarification, Bye.


>> I will be happy to stack more patches about this topic during the 3.16
>> development phase.
>>
>>
>> Otherwise, the 5 patches by Voice go into at91-3.16-dt branch.
>>
>> Thanks, bye.
>>
>>
>>>  .../devicetree/bindings/sound/atmel-wm8904.txt     |  2 ++
>>>  arch/arm/boot/dts/sama5d3.dtsi                     |  6 ++++++
>>>  arch/arm/boot/dts/sama5d3xmb.dtsi                  | 11 +++++++++-
>>>  sound/soc/atmel/atmel_wm8904.c                     | 25 +++++++++++-----------
>>>  4 files changed, 31 insertions(+), 13 deletions(-)
>>>
>>
> 
> 
> 


-- 
Nicolas Ferre
