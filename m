Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaCZHwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:52:50 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55199 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:52:48 -0400
Date: Wed, 26 Mar 2014 07:52:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: Re: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Message-ID: <20140326075243.GE24823@lee--X1>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
 <93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
 <20140311122725.GK21216@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB7A2AFD1F8@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7A2AFD1F8@SW-EX-MBX01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I realise that you and Alessandro are very busy (I have not often seen
> Alessandro do any posting in the past fortnight), but a  couple of weeks
> ago I sent an RTC patch set with register.h changes ...
> 
> >> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> >>
> >> Add the RTC driver for DA9063.
> <snip>
> >> The original patch is here:
> >>  - https://lkml.org/lkml/2014/3/6/346
> 
> I believe you applied the first half of my alterations here:
> https://lkml.org/lkml/2014/3/6/348
> https://lkml.org/lkml/2014/3/10/369
> 
> And the other half, was Acked by Alessandro Zummo here:
> https://lkml.org/lkml/2014/3/7/112
> 
> On 11 March 2014 12:27, Lee Jones wrote:
> >
> >Alessandro,
> >  Are you happy for me to take this set through the MFD tree and send
> >  you a pull-request for an immutable branch?
> >
> 
> There was a suggestion that this RTC patch could be taken through by you?
> Can I ask if this still an option please?
> 
> I tried to contact Alessandro after about 1 week, but I guess that other things
> are getting in the way and I have not had a reply.
> https://lkml.org/lkml/2014/3/21/248
> 
> The reason I ask -- is because I have several patches waiting to add support
> for an older variant of the silicon, but in order to send those changes I will
> need to patch the pending RTC with the updates.

I can't really take the RTC patches without Alessandro's consent.
Besides, the merge window is going to open in about a week. I'm sorry
to say this, but I think this set is best left for v3.16 now. That
also gives Alessandro a while to reply properly.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
