Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaAWUna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:43:30 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:36986 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAWUn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:43:29 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:cda5:d5b8:bf47:af28]
In-Reply-To: <DBC6E587-D188-4DA7-B898-D1DF34613320@codeaurora.org>
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
	<878uu6y5im.fsf@paris.lan>
	<DBC6E587-D188-4DA7-B898-D1DF34613320@codeaurora.org>
Date: Thu, 23 Jan 2014 12:43:28 -0800
Message-ID: <CAOesGMgDg5KyvV9Gj0NeDnWYPQN+EZBzm18mSTku+VZOApVxyA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Enable clock controllers on MSM
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:59 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Jan 23, 2014, at 11:25 AM, Kevin Hilman <khilman@linaro.org> wrote:
>
>> Stephen Boyd <sboyd@codeaurora.org> writes:
>>
>>> These patches add the clock controller nodes, enable the clock drivers
>>> on MSM based platforms, and hook it up enough to get the serial console
>>> working. This is based on the merge of Mike's clk-next branch with
>>> linux-next-20140116. The changes need the clk-next branch because that's
>>> where the DTS include files landed.
>>
>> I forgot to repond to this earlier, but I tested this on top of -next
>> and it gets the dragonboard booting w/mainline.  Yay!
>>
>>> Perhaps this can be applied after 3.14-rc1 is out?
>>
>> Yeah, sounds good.
>>
>> Kevin
>
> We’ll need arm-soc to pull in the clk changes from Mike’s tree for that.

They're queued for this merge window, right? If so, they'll be in -rc1
and the dependency will be solved before we apply the patches.


-Olof
