Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3IIVmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:42:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51175 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3IIVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:42:15 -0400
Message-ID: <522E40B2.9010301@codeaurora.org>
Date: Mon, 09 Sep 2013 14:42:10 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv3 1/2] ARM: msm: Add support for APQ8074 Dragonboard
References: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org> <20130906215051.GA29253@quad.lixom.net> <522E09E6.8040300@codeaurora.org> <FFE100A7-8AD6-4E0D-9F64-120DA3564F89@codeaurora.org> <522E21A8.4060408@wwwdotorg.org> <FA33E8F4-3F85-4D8B-83E1-96F5A8F76CE6@codeaurora.org> <522E3BC9.1030105@wwwdotorg.org> <CA05A23E-41CF-4EC6-BB2D-36105048700B@codeaurora.org>
In-Reply-To: <CA05A23E-41CF-4EC6-BB2D-36105048700B@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/2013 2:25 PM, Kumar Gala wrote:
> <snip>
> On Fri, Sep 06, 2013 at 12:32:22PM -0700, Rohit Vaswani wrote:
>>>>>>>> This patch adds basic board support for APQ8074 Dragonboard
>>>>>>>> <snip>
>>>>>>>> dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
>>>>>>>> -	msm8960-cdp.dtb
>>>>>>>> +	msm8960-cdp.dtb \
>>>>>>>> +	apq8074-dragonboard.dtb
>>>>>>> Please add boards alphabetically.
>>>>>> Will do.
>>>>>>>> dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>>>>>>> 	armada-370-mirabox.dtb \
>>>>>>>> 	armada-370-rd.dtb \
>>>>>>>> diff --git a/arch/arm/boot/dts/apq8074-dragonboard.dts b/arch/arm/boot/dts/apq8074-dragonboard.dts
>>>>>>>> new file mode 100644
>>>>>>>> index 0000000..5b7b6a0
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/arch/arm/boot/dts/apq8074-dragonboard.dts
>>>>>>> arch/arm/boot/dts/ is getting really crowded. It's been working best if the SoC
>>>>>>> family or vendor is used as a prefix to keep things a bit more organized. In
>>>>>>> that spirit, prefixing these with msm-<foo> makes sense. Can you please do so?
>>>>>> Sure. But the board is called an APQ8074 and we wanted to keep the naming consistent with that.
>>>>> If we do this we should use qcom, not msm as the prefix.  Match the device tree vendor prefix.

Coming back to this, it would be better if the naming to be consistent 
with what we call our ARCH - msm and not qcom.
msm8974-dragonboard signifies quite clearly what the board is.

>>>> <snip> 


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

