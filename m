Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbbAGKbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:31:24 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54393 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbbAGKbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:31:21 -0500
Message-ID: <54AD0AD9.3010308@st.com>
Date: Wed, 7 Jan 2015 11:30:49 +0100
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH 1/2] pinctrl: st: avoid multiple mutex lock
References: <1420452254-30625-1-git-send-email-patrice.chotard@st.com>	<1420452254-30625-2-git-send-email-patrice.chotard@st.com> <CACRpkdbOftsepHFBv32j-ty2+N3vDJPP27iMEWwZKO3ciRv0ug@mail.gmail.com>
In-Reply-To: <CACRpkdbOftsepHFBv32j-ty2+N3vDJPP27iMEWwZKO3ciRv0ug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.254.1]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-07_05:2015-01-07,2015-01-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus
On 01/07/2015 10:44 AM, Linus Walleij wrote:
> On Mon, Jan 5, 2015 at 11:04 AM, Patrice CHOTARD <patrice.chotard@st.com> wrote:
>
>> From: Francesco VIRLINZI <francesco.virlinzi@st.com>
>>
>> Using the sysfs inteface to inspect the pins configuration
>> the system can walk around a path which acquires the same
>> mutex twice.
>>
>> On STiH407 platform, for example :
>> cat /sys/kernel/debug/pinctrl/920f080.pin-controller-front0/pinconf-pins
>> hangs the kernel and never returns.
>>
>> With this patch the mutex is temporary freed.
>>
>> Signed-off-by: Francesco Virlinzi <francesco.virlinzi@st.com>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> Patch applied to fixes. Sorry for the delay.

Don't worry ;-)

Thanks

>
> Yours,
> Linus Walleij

