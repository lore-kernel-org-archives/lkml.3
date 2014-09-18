Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaIRHIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:08:43 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29310 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaIRHIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:08:42 -0400
Message-ID: <541A84F6.20509@imgtec.com>
Date: Thu, 18 Sep 2014 08:08:38 +0100
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        "John Crispin" <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/24] MIPS GIC cleanup, part 1
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>	<54196086.9030204@imgtec.com> <CAL1qeaGF2rZ3qRBwWa24-Jun1GB=-i2ibartqAS+z_U9G33Wdw@mail.gmail.com>
In-Reply-To: <CAL1qeaGF2rZ3qRBwWa24-Jun1GB=-i2ibartqAS+z_U9G33Wdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 06:42 PM, Andrew Bresticker wrote:
> On Wed, Sep 17, 2014 at 3:20 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
>> On 09/16/2014 12:51 AM, Andrew Bresticker wrote:
>>> The current MIPS GIC driver and the platform code using it are rather
>>> ugly and could use a good cleanup before adding device-tree support [0].
>>> This major issues addressed in this series are converting the GIC (and
>>> platforms using it) to use IRQ domains and properly mapping interrupts
>>> through the GIC instead of using it transparently.  For part 2 I plan
>>> on: updating the driver to use proper iomem accessors, cleaning up and
>>> moving the GIC clocksource driver to drivers/clocksource/, adding DT
>>> support, and possibly converting the GIC driver to use generic irqchip.
>>>
>>> Patches 1-16 are cleanups for the existing GIC driver and prepare
>>> platforms
>>> using it for the switch to IRQ domains and using the GIC in a
>>> non-transparent
>>> way.
>>>
>>> Patches 17-24 convert the GIC driver to use IRQ domains and updates the
>>> platforms using it to properly map GIC interrupts instead of using the
>>> static
>>> routing tables to make the GIC appear transparent.
>>>
>>> I've tested this series on Malta and, with additional patches, on the
>>> DT-enabled Danube platform.  Unfortunately I do not have SEAD-3 hardware,
>>> so that has only been compile tested.  Compile tested on all other
>>> affected
>>> architectures (ath79, ralink, lantiq).
>>
>> I boot tested this on sead3 without problems.
> Thanks Qais!  Can I add your Tested-by for the series?

Tested-and-reviewed-by: Qais Yousef <qais.yousef@imgtec.com>
