Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaAWV6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:58:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaAWV6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:58:05 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 0/2] Enable clock controllers on MSM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAOesGMgDg5KyvV9Gj0NeDnWYPQN+EZBzm18mSTku+VZOApVxyA@mail.gmail.com>
Date: Thu, 23 Jan 2014 15:57:58 -0600
Cc: Kevin Hilman <khilman@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <69BE1300-36E8-400B-BD77-DB89740C10D2@codeaurora.org>
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org> <878uu6y5im.fsf@paris.lan> <DBC6E587-D188-4DA7-B898-D1DF34613320@codeaurora.org> <CAOesGMgDg5KyvV9Gj0NeDnWYPQN+EZBzm18mSTku+VZOApVxyA@mail.gmail.com>
To: Olof Johansson <olof@lixom.net>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2014, at 2:43 PM, Olof Johansson <olof@lixom.net> wrote:

> On Thu, Jan 23, 2014 at 11:59 AM, Kumar Gala <galak@codeaurora.org> wrote:
>> 
>> On Jan 23, 2014, at 11:25 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> 
>>> Stephen Boyd <sboyd@codeaurora.org> writes:
>>> 
>>>> These patches add the clock controller nodes, enable the clock drivers
>>>> on MSM based platforms, and hook it up enough to get the serial console
>>>> working. This is based on the merge of Mike's clk-next branch with
>>>> linux-next-20140116. The changes need the clk-next branch because that's
>>>> where the DTS include files landed.
>>> 
>>> I forgot to repond to this earlier, but I tested this on top of -next
>>> and it gets the dragonboard booting w/mainline.  Yay!
>>> 
>>>> Perhaps this can be applied after 3.14-rc1 is out?
>>> 
>>> Yeah, sounds good.
>>> 
>>> Kevin
>> 
>> We’ll need arm-soc to pull in the clk changes from Mike’s tree for that.
> 
> They're queued for this merge window, right? If so, they'll be in -rc1
> and the dependency will be solved before we apply the patches.
> 

Yeah, they look like they are in Mike’s pull request for Linus.  So hopefully they’ll show up in -rc1 (wasn’t sure if Mike intended them for 3.14 or not).

What’s the feeling about pushing DT and defconfig changes into 3.14 (or do we just queue them up for 3.15)?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

