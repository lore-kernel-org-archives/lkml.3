Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946192Ab3FUV1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:27:21 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43653 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946011Ab3FUV1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:27:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130621170407.20448.35605@quantum>
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
	<20130621170407.20448.35605@quantum>
Date: Fri, 21 Jun 2013 22:27:16 +0100
X-Google-Sender-Auth: ZuUYYFfVMxHnbG7kCx1_nRGBxRU
Message-ID: <CAAG0J9-F0P67=oaE5UHhmgd3Wz4k4XjsRjWShxmKOqicAyrhfw@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] clk: implement remuxing during set_rate
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Stephen Boyd <sboyd@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 June 2013 18:04, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting James Hogan (2013-06-13 09:05:57)
>> This patchset adds support for automatic selection of the best parent
>> for a clock mux, i.e. the one which can provide the closest clock rate
>> to that requested. It can be disabled by a new CLK_SET_RATE_NO_REPARENT
>> flag (which is set for all uses of clk_register_mux().
>>
>> This works by way of adding a new op, determine_rate, similar to
>> round_rate but with an extra parameter to allow the clock driver to
>> optionally select a different parent clock. This is used in
>> clk_calc_new_rates to decide whether to initiate a set_parent operation.
>
> Hi James,
>
> I'm going to hold off on this one for 3.11. I'll revisit it after the
> next merge window.

Okay, no worries.

Thanks
James
