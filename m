Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaGNJCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:02:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35456 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaGNJC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:02:29 -0400
Message-ID: <53C39C8C.6060604@ti.com>
Date: Mon, 14 Jul 2014 14:32:04 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sachin Kamat <spk.linux@gmail.com>
CC: open list <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v2 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
References: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>	<53C39B32.9060001@ti.com> <CAK5sBcG+UZ86cAFKoAf4Y62yrOafpzBGd-wz=PqWJRg1g8pOFQ@mail.gmail.com>
In-Reply-To: <CAK5sBcG+UZ86cAFKoAf4Y62yrOafpzBGd-wz=PqWJRg1g8pOFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 14 July 2014 02:29 PM, Sachin Kamat wrote:
> Hi,
> 
> On Mon, Jul 14, 2014 at 2:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi,
>>
>> On Wednesday 09 July 2014 05:19 PM, Sachin Kamat wrote:
>>> Since the USB 2.0 PHYs are required with EHCI/OHCI USB drivers and
>>> USB gadget controller supported by the DWC2 gadget driver, make it
>>> depend on them and default to ARCH_EXYNOS as they are meant for
>>> Exynos platforms. Also, make the sub-drivers silent options enabling
>>> them based on the SoC platforms that they are meant to work with. This
>>> will make life easier for end users who do not have any way knowing the
>>> dependencies.
>>
>> There is a new Exynos PHY in town, Exynos 3250. Can you rebase your patch on
>> top of that?
> 
> Sure. But I did not see it in linux-next yet. Is it merged somewhere?

It's in the list. I can push it to my tree if that helps.

-Kishon
> 
