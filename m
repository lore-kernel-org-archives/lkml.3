Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaAOKvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:51:24 -0500
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:13620 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468AbaAOKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:51:20 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 05:51:20 EST
Message-ID: <52D66699.8020309@itdev.co.uk>
Date: Wed, 15 Jan 2014 10:44:41 +0000
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, adlr@chromium.org
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v6
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>	<20130718194739.GA559@polaris.bitmath.org>	<520CFA0D.4090905@itdev.co.uk>	<20130815160734.GB12196@core.coreip.homeip.net>	<522F2590.1080103@itdev.co.uk> <CAPDwgkOo7FYLujk16kJM=BqmXRKvZ2S_LOYURW0cXT5t=cmi6w@mail.gmail.com>
In-Reply-To: <CAPDwgkOo7FYLujk16kJM=BqmXRKvZ2S_LOYURW0cXT5t=cmi6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yufeng Shen wrote:
> On Tue, Sep 10, 2013 at 9:58 AM, Nick Dyer <nick.dyer@itdev.co.uk
> <mailto:nick.dyer@itdev.co.uk>> wrote:
>> Dmitry Torokhov wrote:
>> > On Thu, Aug 15, 2013 at 04:55:57PM +0100, Nick Dyer wrote:
>> >> rydberg@euromail.se <mailto:rydberg@euromail.se> wrote:
>> >>> First: thanks for the patches and you work on this driver.
>> >>
>> >> Thank you for your time in looking at these changes.
>> >>
>> >>> Now, I don't swear much, but I would like to emphasize line 161 of
>> >>> Documentation/SubmittingPatches:
>> >>>
>> >>> **Do not send more than 15 patches at once to the vger mailing
> lists!!!***
>> >>>
>> >>> One reason that should be obvious by now is that your work will be
>> >>> attended to much quicker. One may think that it is more efficient to
>> >>> send the whole backlog at once, but in fact, the time it takes to get
>> >>> a patchset accepted is inversely proportional to the length of the
>> >>> patchset. So please, keep it small and simple next time,
>> >>
>> >> Apologies. I will split this lot up into several smaller series of
> patches.
>> >
>> > Wait, I am in the process of applying it actually...
>>
>> I wonder, have you made any progress with this? Is there any way I can
>> assist?
>
> Hey Dimitry,
> 
> What's the status on this ?
> 
> I noticed that at  /pub/scm/linux/kernel/git/dtor/input, branch
> atmel-mxt-ts has part of Nick's patches applied
> but not all. The upstream tree and Nick's tree
>  https://github.com/ndyer/linux/commits/for-next are still
> significantly diverged.
> 
> I am wondering any plan on your side to apply more patches that sent out by
> Nick ?
> 
> We (Chromium authors) are planning on bringing our local tree of atmel
> driver to be as close as possible to
> upstream and trying to figure out what's the best tree to rebase against.

I was considering picking up the patches that Dimitry has already reviewed
and rebasing them against the current mainline to try and get things moving
again - would that be useful?
