Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaAVSL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:11:27 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40132 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaAVSL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <52E00703.5080001@codeaurora.org>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
 <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com>
 <20140122045937.GB23869@kroah.com> <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
 <52E00703.5080001@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 22 Jan 2014 10:11:04 -0800
Message-ID: <CAPtuhThZdDkKq_fruaduPknpXxCTHgCA7mCnDDh+vS_OiUy+1w@mail.gmail.com>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: SeongJae Park <sj38.park@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 9:59 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 01/21/14 21:23, SeongJae Park wrote:
>> On Wed, Jan 22, 2014 at 1:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Wed, Jan 22, 2014 at 12:05:57PM +0900, SeongJae Park wrote:
>>>> Dear Greg, Mike,
>>>>
>>>> May I ask your answer or other opinion, please?
>>> It's the middle of the merge window, it's not time for new development,
>>> or much time for free-time for me, sorry.  Feel free to fix it the best
>>> way you know how.
>> Oops, I've forgot about the merge window. Thank you very much for your
>> kind answer.
>> Sorry if I bothered you while you're in busy time.
>> Because the build problem is not a big deal because it exists only in
>> -next tree,
>> I will wait until merge window be closed and then fix it again if it
>> still exist.
>>
>
> I've already sent a patch that exports this and other clock provider
> functions. Please use this one:
>
> https://patchwork.kernel.org/patch/3507921/

I'm going to take Stephen's patch into a fixes branch and send it as
part of a pull request. Maybe -rc1 or -rc2 at the latest.

Thanks all.

Regards,
Mike

>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
