Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaAWCFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:05:38 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39230 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaAWCFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:05:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAPtuhThZdDkKq_fruaduPknpXxCTHgCA7mCnDDh+vS_OiUy+1w@mail.gmail.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
 <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com>
 <20140122045937.GB23869@kroah.com> <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
 <52E00703.5080001@codeaurora.org> <CAPtuhThZdDkKq_fruaduPknpXxCTHgCA7mCnDDh+vS_OiUy+1w@mail.gmail.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Thu, 23 Jan 2014 11:05:15 +0900
Message-ID: <CAEjAshq59ViL6C6ig=Rf-54J1OL9BLzEB2WtTyXuXEFg5W_Y0Q@mail.gmail.com>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 3:11 AM, Mike Turquette <mturquette@linaro.org> wrote:
> On Wed, Jan 22, 2014 at 9:59 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 01/21/14 21:23, SeongJae Park wrote:
>>> On Wed, Jan 22, 2014 at 1:59 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>> On Wed, Jan 22, 2014 at 12:05:57PM +0900, SeongJae Park wrote:
>>>>> Dear Greg, Mike,
>>>>>
>>>>> May I ask your answer or other opinion, please?
>>>> It's the middle of the merge window, it's not time for new development,
>>>> or much time for free-time for me, sorry.  Feel free to fix it the best
>>>> way you know how.
>>> Oops, I've forgot about the merge window. Thank you very much for your
>>> kind answer.
>>> Sorry if I bothered you while you're in busy time.
>>> Because the build problem is not a big deal because it exists only in
>>> -next tree,
>>> I will wait until merge window be closed and then fix it again if it
>>> still exist.
>>>
>>
>> I've already sent a patch that exports this and other clock provider
>> functions. Please use this one:
>>
>> https://patchwork.kernel.org/patch/3507921/
>
> I'm going to take Stephen's patch into a fixes branch and send it as
> part of a pull request. Maybe -rc1 or -rc2 at the latest.

Got it. Thank you for let me know :)

>
> Thanks all.
>
> Regards,
> Mike
>
>>
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> hosted by The Linux Foundation
>>
