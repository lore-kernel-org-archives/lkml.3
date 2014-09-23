Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaIWHkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:40:19 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43542 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIWHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:40:18 -0400
Message-ID: <542123DC.7060408@collabora.com>
Date: Tue, 23 Sep 2014 09:40:12 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 00/10] Per-user clock constraints
References: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com> <20140922150658.GM5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140922150658.GM5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 05:06 PM, Russell King - ARM Linux wrote:
> On Mon, Sep 22, 2014 at 04:12:02PM +0200, Tomeu Vizoso wrote:
>> Hello,
>>
>> my branch was finally processed by the 0day build farm and I have fixed the
>> three issues that came up:
> 
> Patch 3 did not come through, so I can't see the changes there.

Yeah, I think all mailing lists choke on it because of its size and the
number of recipients, except linuxppc-dev:

http://patchwork.ozlabs.org/patch/391967/

You were on CC though.

> I'm
> assuming that there's some changes to clkdev in there which I need to
> see.

Nope, that one doesn't touch clkdev.

>> * export __clk_get and __clk_put, so they can be used by clock implementations
>> in modules that previously used clk_get and clk_put.
> 
> This is something I'm not happy about.  We don't want people getting
> access to these low level functions.

I see, will think something about it.

Thanks,

Tomeu

