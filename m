Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKQV3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:29:10 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63732 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaKQV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:29:06 -0500
Message-ID: <546A689E.3050207@linaro.org>
Date: Mon, 17 Nov 2014 22:29:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, John Crispin <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5 4/4] clocksource: mips-gic: Add device-tree support
References: <1415821419-26974-1-git-send-email-abrestic@chromium.org>	<1415821419-26974-5-git-send-email-abrestic@chromium.org>	<546A66EA.3090107@linaro.org> <CAL1qeaHpK0a+ONK3bhVrRk-G7iwRw_HwpjtLwi6E6EJ+rccbww@mail.gmail.com>
In-Reply-To: <CAL1qeaHpK0a+ONK3bhVrRk-G7iwRw_HwpjtLwi6E6EJ+rccbww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 10:26 PM, Andrew Bresticker wrote:
> On Mon, Nov 17, 2014 at 1:21 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 11/12/2014 08:43 PM, Andrew Bresticker wrote:
>>>
>>> Parse the GIC timer frequency and interrupt from the device-tree.
>>>
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>>
>> Hi Andrew,
>>
>> through which tree is this patch supposed to go ?
>>
>> Is there any dependency ?
>
> There are quite a few dependencies, so this series and all the other
> MIPS GIC stuff is going through the MIPS tree.

Ok thanks.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

