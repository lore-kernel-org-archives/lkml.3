Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbaJ2RFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:05:20 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:46895 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057AbaJ2RFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:05:18 -0400
Message-ID: <54511E49.6090907@imgtec.com>
Date: Wed, 29 Oct 2014 17:05:13 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>	<1414541562-10076-3-git-send-email-abrestic@chromium.org>	<5450C915.9030600@imgtec.com> <CAL1qeaGm1Ma=B-gJV2ovnLNYFooq6bv12rODq4d8cGtKLeNy-g@mail.gmail.com>
In-Reply-To: <CAL1qeaGm1Ma=B-gJV2ovnLNYFooq6bv12rODq4d8cGtKLeNy-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 04:56 PM, Andrew Bresticker wrote:
> On Wed, Oct 29, 2014 at 4:01 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
>> On 10/29/2014 12:12 AM, Andrew Bresticker wrote:
>>> +- mti,available-cpu-vectors : Specifies the list of CPU interrupt vectors
>>> +  to which the GIC may route interrupts.  May contain up to 6 entries,
>>> one
>>> +  for each of the CPU's hardware interrupt vectors.  Valid values are 2 -
>>> 7.
>>> +  This property is ignored if the CPU is started in EIC mode.
>>> +
>>
>> Wouldn't it be better to have this in the reversed sense ie:
>> mti,nonavailable-cpu-vectors? I think the assumption that by default they're
>> all available unless something else is connected to them which is unlikely
>> in most cases. It can be made optional property then.
>>
>> I don't have a strong opinion about it though.
> Actually, I think I like the reversed sense as well.  Perhaps
> "mti,reserved-cpu-vectors"?

Yep that's a better wording for sure :)
