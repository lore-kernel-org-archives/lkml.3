Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbbA0G3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:29:40 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42881 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbA0G3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:29:37 -0500
Message-ID: <54C7304C.7010706@collabora.com>
Date: Tue, 27 Jan 2015 07:29:32 +0100
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v13 0/6] Per-user clock constraints
References: <1422011024-32283-1-git-send-email-tomeu.vizoso@collabora.com> <54C6E1FB.5030907@codeaurora.org>
In-Reply-To: <54C6E1FB.5030907@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 01:55 AM, Stephen Boyd wrote:
> On 01/23/15 03:03, Tomeu Vizoso wrote:
>> Hi,
>>
>> in this v13 I have:
>>
>> * added the latest R-b tags from Stephen,
>>
>> * split some lines that went over the 80-char limit,
>>
>> * made explicit in the docs that the range limits are inclusive, and
>>
>> * removed an ifdef in clkdev.c by adding a dev_id param to __of_clk_get_by_name.
>>
> 
> I think this patch series is ready to go except for the last one? Do you
> plan on polishing that one some more?

Not in time for 3.20, I'm afraid. Want to spin first each of my other
series, then I will go back to it.

Regards,

Tomeu

