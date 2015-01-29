Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbbA2O3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:29:42 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43687 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbbA2O3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:29:39 -0500
MIME-Version: 1.0
In-Reply-To: <54C9D62B.7000602@collabora.com>
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com>
 <54C6E1FB.5030907@codeaurora.org> <54C888EF.2080500@collabora.com>
 <20150129022633.22722.78592@quantum> <54C9D62B.7000602@collabora.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 29 Jan 2015 06:29:16 -0800
Message-ID: <CAPtuhTi3F58yR_OE2toXMp1Wqi==CfJLZ+M8+dcF6t68WqZqqQ@mail.gmail.com>
Subject: Re: [PATCH v13 0/6] Per-user clock constraints
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:41 PM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> On 01/29/2015 03:26 AM, Mike Turquette wrote:
>> Quoting Tomeu Vizoso (2015-01-27 22:59:59)
>>> On 01/27/2015 01:55 AM, Stephen Boyd wrote:
>>>> On 01/23/15 03:03, Tomeu Vizoso wrote:
>>>>> Hi,
>>>>>
>>>>> in this v13 I have:
>>>>>
>>>>> * added the latest R-b tags from Stephen,
>>>>>
>>>>> * split some lines that went over the 80-char limit,
>>>>>
>>>>> * made explicit in the docs that the range limits are inclusive, and
>>>>>
>>>>> * removed an ifdef in clkdev.c by adding a dev_id param to __of_clk_get_by_name.
>>>>>
>>>>
>>>> I think this patch series is ready to go except for the last one? Do you
>>>> plan on polishing that one some more?
>>>
>>> Hi Mike,
>>>
>>> do you plan to merge this for 3.20?
>>
>> Tomeu,
>>
>> Yes. I have taken patches 1-5.
>>
>> I edited patch #3 to adapt clk_has_parent for struct clk_core.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/clk/linux.git/commit/?h=clk-next&id=59cf3fcf9bafe8fdb6183f13dafb81fc8213a8f9
>>
>> Patch #4 need an update to convert sun6i_ahb1_clk_determine_rate to have
>> min/max rates.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/clk/linux.git/commit/?h=clk-next&id=cb75a8fcd14e71c115decc416dd8d223e7c8b2e0
>>
>> Can you look it over and make sure I didn't screw anything up?
>
> Yup, they look good to me. I have also done some testing here.

Great! Thanks again for your hard work on this series.

Regards,
Mike

>
> Thanks,
>
> Tomeu
>
