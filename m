Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3LBOCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:02:09 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52092 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab3LBOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:02:06 -0500
Message-ID: <529C91A8.3030401@st.com>
Date: Mon, 2 Dec 2013 13:56:56 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linus.walleij@linaro.org>,
        <linux-mtd@lists.infradead.org>, <angus.clark@st.com>
Subject: Re: [PATCH v3 36/36] ARM: STi: Add support for the FSM Serial Flash
 Controller
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-37-git-send-email-lee.jones@linaro.org> <529C858B.1040601@st.com> <20131202132013.GF31626@lee--X1> <529C8A99.1020204@st.com> <20131202134348.GG31626@lee--X1>
In-Reply-To: <20131202134348.GG31626@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/13 13:43, Lee Jones wrote:
> On Mon, 02 Dec 2013, srinivas kandagatla wrote:
> 
>> On 02/12/13 13:20, Lee Jones wrote:
>>>>> +		/* FSM */
>>>>> +		spifsm: spifsm@fe902000{
>>>>> +		        compatible         = "st,spi-fsm", "simple-bus";
>>>> "simple-bus" is redundant here.
>>>
>>> Yes I agree, good spot.
>>>
>>> I removed it from the Documentation, but missed this one.
>>>
>>> If I remove it, can I add your Ack for the remainder of the patch?
>> Yes,
>>
>> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>
>> You should be aware that arch/arm/boot/dts/stih416-b2105.dts is not in
>> mainline yet.
> 
> Yes, I am aware of this. Are you queuing patches for it?
Yes, I will post this soon.

thanks,
srini
> 
>>>>> +		        reg                =  <0xfe902000 0x1000>;
>>>>> +		        reg-names          = "spi-fsm";
>>>>> +		        pinctrl-0          = <&pinctrl_fsm>;
>>>>> +
>>>>> +			st,syscfg	   = <&syscfg_rear>;
>>>>> +		        st,boot-device-reg = <0x958>;
>>>>> +		        st,boot-device-spi = <0x1a>;
>>>>> +
>>>>> +		        status = "okay";
>>>>> +		};
>>>
>>
> 

