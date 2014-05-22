Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEVWO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:14:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54725 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEVWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:14:57 -0400
Message-ID: <537E84F3.6020207@gmail.com>
Date: Fri, 23 May 2014 01:14:59 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] ARM: berlin: add pinctrl support
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkda6-W6rNXtAbcTs6dgp4WLExXra6P_dqQbuYsRWi7MaOw@mail.gmail.com>
In-Reply-To: <CACRpkda6-W6rNXtAbcTs6dgp4WLExXra6P_dqQbuYsRWi7MaOw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 12:11 AM, Linus Walleij wrote:
> On Mon, May 19, 2014 at 7:36 PM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
> 
>> but can you please drop the Berlin pinctrl patches
>> and reconsider taking the reworked driver instead?
> 
> Sure I applied patches 1 thru 4 to the pin control tree.
> The rest you need to carry in some ARM SoC tree or
> similar.

Great, thanks. Having it in is a huge benefit as future device
drivers will depend on at least some pinctrl. Functionally it is
ok, Mike's request for clock node rework smashed my time schedule.

> I don't mind the driver being half-merged like this, because
> it means we can work on consolidating the utils code
> in the next cycle.

Sure, pinctrl properties consolidation is on my list for next
cycle.

Anyway, sorry for the late mess with it, I am still learning on
the first real arm/mach-maintainer cycle.

Sebastian
