Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaLIOTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:19:13 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40804 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaLIOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:19:10 -0500
MIME-Version: 1.0
In-Reply-To: <548703C4.1030300@collabora.com>
References: <1417709696-29281-1-git-send-email-tomeu.vizoso@collabora.com>
 <CAAVeFuJkpuWocEDTfSAK7_UfhZvqOfYJY6sLgsy9i+KcMAkbCQ@mail.gmail.com> <548703C4.1030300@collabora.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 23:18:49 +0900
Message-ID: <CAAVeFuJY_31ayqnoY65uCoP9AadvucEARmuv4jr_DoS6Aj5rGA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Add support for Tegra Activity Monitor
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 11:14 PM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> On 12/09/2014 06:38 AM, Alexandre Courbot wrote:
>> On Fri, Dec 5, 2014 at 1:14 AM, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
>>> Hello,
>>>
>>> this v3 addresses the comments that the devfreq implementation got, namely:
>>>
>>> * Address misc. style issues found by Thierry and Alexander
>>> * Added helpers for register i/o
>>> * Further documented the structs
>>> * Enable the ACTMON after the IRQ handler has been installed
>>> * Disable the ACTMON before removing the IRQ handler
>>> * Add governor in a subsys initcall
>>>
>>> There's an open question on whether some functionality currently in this
>>> devfreq driver should be moved into the devfreq framework, but without knowing
>>> of other SoC family that would benefit from it, I'm reticent. It would be
>>> great to hear from the devfreq maintainers if they have any plans regarding
>>> this, or if they have any suggestion.
>>
>> I cannot make a thorough review because of the problem I mentioned in
>> patch 3/3, but I am guessing this series is converging towards what we
>> want. Now the main question will be how we can leverage Arto's
>> watermark series for this one. I am ready to bet that doing so can
>> reduce quite a lot of code.
>>
>> Since you are likely to be the first user of the watermarking feature,
>> could you comment on its potential shortcomings and whatever needs to
>> be fixed to best implement ACTMON support using it? I will try to push
>> it myself, but you are obviously in a better position to understand
>> what is needed.
>
> Sure, I'm still playing with the idea, but I have sent a few questions
> to that thread already.

Seen that, thanks! After seeing your comments I come to thing that
maybe we should merge ACTMON support first and then adapt it to use
watermarking afterwards. I'm all for incremental changes and after 4
iterations this series should be close to completion now - would be
sad to go back to the design board at this stage.

Reviewing your v4 is on my schedule for tomorrow, thanks for your patience!
