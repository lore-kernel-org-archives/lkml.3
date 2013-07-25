Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3GYKiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:38:07 -0400
Received: from multi.imgtec.com ([194.200.65.239]:58855 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab3GYKhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:37:54 -0400
Message-ID: <51F0EAE8.90303@imgtec.com>
Date: Thu, 25 Jul 2013 10:07:52 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v5 0/5] clk: implement remuxing during set_rate
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com> <20130621170407.20448.35605@quantum> <CAAG0J9-F0P67=oaE5UHhmgd3Wz4k4XjsRjWShxmKOqicAyrhfw@mail.gmail.com> <20130724183912.GC27761@codeaurora.org>
In-Reply-To: <20130724183912.GC27761@codeaurora.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_25_11_35_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/13 19:39, Stephen Boyd wrote:
> On 06/21, James Hogan wrote:
>> On 21 June 2013 18:04, Mike Turquette <mturquette@linaro.org> wrote:
>>> Quoting James Hogan (2013-06-13 09:05:57)
>>>> This patchset adds support for automatic selection of the best parent
>>>> for a clock mux, i.e. the one which can provide the closest clock rate
>>>> to that requested. It can be disabled by a new CLK_SET_RATE_NO_REPARENT
>>>> flag (which is set for all uses of clk_register_mux().
>>>>
>>>> This works by way of adding a new op, determine_rate, similar to
>>>> round_rate but with an extra parameter to allow the clock driver to
>>>> optionally select a different parent clock. This is used in
>>>> clk_calc_new_rates to decide whether to initiate a set_parent operation.
>>>
>>> Hi James,
>>>
>>> I'm going to hold off on this one for 3.11. I'll revisit it after the
>>> next merge window.
>>
>> Okay, no worries.
>>
> 
> Has a new patchset been sent out? I'd like to see this merge in
> 3.12.

Not yet, but I'll try and get it updated and resent early next week.

Cheers
James

