Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaDDAxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 20:53:01 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58702 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaDDAwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 20:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140403234850.GA13956@debian>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
	<533AFF77.5030106@codeaurora.org>
	<CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
	<CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
	<CAGXu5jKyzbRR4S0+0daygWcE2-BbFi1X6MFAkPqTNbGiT6huSQ@mail.gmail.com>
	<20140403234850.GA13956@debian>
Date: Thu, 3 Apr 2014 17:52:55 -0700
X-Google-Sender-Auth: F7t0w2Kp0i_cPa-2A_9Mj6ayKdM
Message-ID: <CAGXu5jLCm8Qg7oQzEjOHtpY5TX2aX1DR4hXtoM_wzeRH4+_JFA@mail.gmail.com>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 4:48 PM, Rabin Vincent <rabin@rab.in> wrote:
> On Thu, Apr 03, 2014 at 04:14:54PM -0700, Kees Cook wrote:
>> On Tue, Apr 1, 2014 at 4:08 PM, Rabin Vincent <rabin@rab.in> wrote:
>> > Here's a patch (probably whitespace damaged, hence also attached) with
>> > which dynamic ftrace works for me on top your other paches.  Tested on
>> > a non-LPAE SMP.
>>
>> Thanks! I'll incorporate calls to set_all_modules_text_rw/ro and see
>> what I can make work.
>
> You can use the patch I posted yesterday for module support:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/244558.html

Yup, that's basically what I had too.

So, even with your patch, I still get faults with ftrace.
probe_kernel_write still errors for me, and I don't see why. I will
send an updated patch series with my current CONFIG_DEBUG_RODATA work
shortly...

-Kees

-- 
Kees Cook
Chrome OS Security
