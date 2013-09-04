Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3IDSgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:36:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59113 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3IDSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:36:52 -0400
Message-ID: <52277DBF.7080104@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:36:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum> <522110AA.7040700@wwwdotorg.org> <20130903232219.10934.67434@quantum>
In-Reply-To: <20130903232219.10934.67434@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 05:22 PM, Mike Turquette wrote:
> Quoting Stephen Warren (2013-08-30 14:37:46)
>> On 08/30/2013 02:33 PM, Mike Turquette wrote:
...
>>> The clock _data_ seems to always have some churn to it. Moving it out to
>>> DT reduces that churn from Linux. My concern above is not about kernel
>>> data size.
>>
>> That sounds like the opposite of what we should be doing.
>>
>> It's fine for kernel code/data to change; that's a natural part of
>> development. Obviously, we should minimize churn, through thorough
>> review, domain knowledge, etc.
> 
> And with the "clock mapping" style bindings we'll end up changing both
> the DT binding definition and the kernel. Not great.

What's a "clock mapping" style binding? I guess that means the style
where you have a single DT node that provides multiple clocks, rather
than one DT node per clock?

If the kernel driver changes its internal data, I don't see why that
would have any impact at all on the DT binding definition. We should be
able to use one DT binding definition with arbitrary drivers.

> And I'll respond to your points below but the whole "relocate the
> problem to DT" argument is simply not my main point. What I want to do
> is increase the usefulness of DT by allowing register-level details into
> the binding which can 

Can you expand upon why a DT that encodes register-level details is more
useful? I can't see why there would be any difference in usefulness.

