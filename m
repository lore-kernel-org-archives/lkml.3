Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbbA2Gly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:41:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46753 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbA2Glx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:41:53 -0500
Message-ID: <54C9D62B.7000602@collabora.com>
Date: Thu, 29 Jan 2015 07:41:47 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v13 0/6] Per-user clock constraints
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com> <54C6E1FB.5030907@codeaurora.org> <54C888EF.2080500@collabora.com> <20150129022633.22722.78592@quantum>
In-Reply-To: <20150129022633.22722.78592@quantum>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 03:26 AM, Mike Turquette wrote:
> Quoting Tomeu Vizoso (2015-01-27 22:59:59)
>> On 01/27/2015 01:55 AM, Stephen Boyd wrote:
>>> On 01/23/15 03:03, Tomeu Vizoso wrote:
>>>> Hi,
>>>>
>>>> in this v13 I have:
>>>>
>>>> * added the latest R-b tags from Stephen,
>>>>
>>>> * split some lines that went over the 80-char limit,
>>>>
>>>> * made explicit in the docs that the range limits are inclusive, and
>>>>
>>>> * removed an ifdef in clkdev.c by adding a dev_id param to __of_clk_get_by_name.
>>>>
>>>
>>> I think this patch series is ready to go except for the last one? Do you
>>> plan on polishing that one some more?
>>
>> Hi Mike,
>>
>> do you plan to merge this for 3.20?
> 
> Tomeu,
> 
> Yes. I have taken patches 1-5.
> 
> I edited patch #3 to adapt clk_has_parent for struct clk_core.
> 
> https://git.kernel.org/cgit/linux/kernel/git/clk/linux.git/commit/?h=clk-next&id=59cf3fcf9bafe8fdb6183f13dafb81fc8213a8f9
> 
> Patch #4 need an update to convert sun6i_ahb1_clk_determine_rate to have
> min/max rates.
> 
> https://git.kernel.org/cgit/linux/kernel/git/clk/linux.git/commit/?h=clk-next&id=cb75a8fcd14e71c115decc416dd8d223e7c8b2e0
> 
> Can you look it over and make sure I didn't screw anything up?

Yup, they look good to me. I have also done some testing here.

Thanks,

Tomeu

