Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaGKLeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:34:06 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57745 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaGKLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:34:05 -0400
Message-ID: <53BFCB83.8020304@st.com>
Date: Fri, 11 Jul 2014 13:33:23 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>
Cc: <kernel@stlinux.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce support
 for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>	<53BD572C.4060406@ti.com>	<20140710153548.GB26886@griffinp-ThinkPad-X1-Carbon-2nd>	<20140711103104.GC30519@lee--X1>	<20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd> <20140711113037.GD30519@lee--X1>
In-Reply-To: <20140711113037.GD30519@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-11_02:2014-07-11,2014-07-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/11/2014 01:30 PM, Lee Jones wrote:
> On Fri, 11 Jul 2014, Peter Griffin wrote:
>> On Fri, 11 Jul 2014, Lee Jones wrote:
>>>> One small point, patch 5 which adds the DT nodes may not apply as the file got
>>>> renamed from stih416-b2020-revE.dts to stih416-b2020e.dts.
>>>
>>> Not required, Git should handle this seamlessly.
>>
>> I didn't ask you to do anything.
>
> Ah, I misread, my bad.
>
>> Also when I made the same mistake, GIT
>> did not handle it seamlessly and I got the following query
>> from Ulf http://www.mail-archive.com/devicetree@vger.kernel.org/msg33926.html
>
> Oh, it looks like the renaming patch went into -rc3 as part of Max's
> -fixes branch.  I assumed it would go in via -next.  This is
> different, so yes, it will have to be rebased onto -rc3.
>
> Maxime,
>    Do you want me to do that, or are you happy to?

Actually, I already rebase the next branch for DT stuff on top of -rc3.
This is not available on stlinux git yet because of mirroring issue.
I will let you know when this is fixed, then you can rebase your DT 
patches on top of it.

Regards,
Maxime

>
>> So in case Kishon has the same problem I thought I'd do a pre-emptive strike!
>
> Yes, good call.
>
