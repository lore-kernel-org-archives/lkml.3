Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbaJ2RYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:24:06 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:44979 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934213AbaJ2RYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:24:03 -0400
Message-ID: <545122AF.303@imgtec.com>
Date: Wed, 29 Oct 2014 17:23:59 +0000
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
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>	<1414541562-10076-3-git-send-email-abrestic@chromium.org>	<5450CAF9.3040902@imgtec.com> <CAL1qeaHEE43n6V-y6XECicPaoEAfTBpyfg8bYJZK0e-pSMAJjw@mail.gmail.com>
In-Reply-To: <CAL1qeaHEE43n6V-y6XECicPaoEAfTBpyfg8bYJZK0e-pSMAJjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 05:08 PM, Andrew Bresticker wrote:
> On Wed, Oct 29, 2014 at 4:09 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
>> On 10/29/2014 12:12 AM, Andrew Bresticker wrote:
>>> +- reg : Base address and length of the GIC registers.
>>>
>> Also except for sead3, the base address should be properly reported by the
>> hardware. The size is fixed (for a specific version of GIC at least - which
>> is also reported by the hardware). So it would be nice to make this
>> optional.
> Even though this is usually probable, I'd prefer to leave this as
> required, or at least "optional, but recommended".  I don't have a
> very strong opinion on it though, but perhaps the device-tree folks
> do?
The biggest advantage I can think of is that it can potentially make GIC 
DT definition more shareable across for instance multiple revisions of 
an SoC that might have the GIC at different base addresses.

I won't insist too much though.
