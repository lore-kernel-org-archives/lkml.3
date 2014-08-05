Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaHELQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:16:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54906 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaHELQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:16:04 -0400
Message-ID: <53E0BC95.7040208@gmail.com>
Date: Tue, 05 Aug 2014 16:44:29 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, broonie@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, b42378@freescale.com,
        b02247@freescale.com
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com> <53E0B926.9010103@gmail.com> <20140805110735.GA16503@MrMyself>
In-Reply-To: <20140805110735.GA16503@MrMyself>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 04:37 PM, Nicolin Chen wrote:
> Hi Varka,
>
> On Tue, Aug 05, 2014 at 04:29:50PM +0530, Varka Bhadram wrote:
>>> diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
>>> index 0f4e238..77864f4 100644
>>> --- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
>>> +++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
>>> @@ -24,6 +24,22 @@ Required properties:
>>>   - big-endian-data: If this property is absent, the little endian mode will
>>>     be in use as default, or the big endian mode will be in use for all the
>>>     fifo data.
>>> +- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
>>> +  that SAI will work in the synchronous mode (sync Tx with Rx) which means
>>> +  both the transimitter and receiver will send and receive data by following
>>> +  receiver's bit clocks and frame sync clocks.
>>> +- fsl,sai-asynchronous: This is a boolean property. If present, indicating
>>> +  that SAI will work in the asynchronous mode, which means both transimitter
>>> +  and receiver will send and receive data by following their own bit clocks
>>> +  and frame sync clocks separately.
>>>
>> Would be readable if it like this...
>>
>> fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
>> 			that SAI will work in the synchronous mode (sync Tx with Rx) which means
>> 			both the transimitter and receiver will send and receive data by following
>> 			receiver's bit clocks and frame sync clocks.
>> - fsl,sai-asynchronous: This is a boolean property. If present, indicating
>> 			that SAI will work in the asynchronous mode, which means both transimitter
>> 			and receiver will send and receive data by following their own bit clocks
>> 			and frame sync clocks separately.
> I agree, however, the doc was initialized in that format. Adding
> indentations for these two appended lines makes the whole text
> look weird. :(

Reading comfortably is important for us...  :-)
see this:http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt#L46

Thanks....

-- 
Regards,
Varka Bhadram.

