Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3JNUTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:19:35 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44958 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab3JNUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <87ob6r625t.fsf@linaro.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
	<1374189690-10810-6-git-send-email-sboyd@codeaurora.org>
	<87k3hf7kvb.fsf@linaro.org>
	<525C3E2F.2030109@codeaurora.org>
	<87ob6r625t.fsf@linaro.org>
Date: Mon, 14 Oct 2013 13:18:32 -0700
Message-ID: <CALAqxLWVWZ+BGhDOMOAGLF6uE+xN9wkMYpxyoa7JGn7d2Djmxg@mail.gmail.com>
Subject: Re: [PATCH v4 05/17] arch_timer: Move to generic sched_clock framework
From: John Stultz <john.stultz@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 1:14 PM, Kevin Hilman <khilman@linaro.org> wrote:
> Stephen Boyd <sboyd@codeaurora.org> writes:
>
>> Can you try this patch?
>
> Yup, your patch gets it booting again.
>
> John, how do you want to proceed on this?  The version of $SUBJECT patch
> that made it to -next doesn't match the one in sent in this thread.

We'll need to get the fix applied to -tip, where my mis-merge landed.

thanks
-john
