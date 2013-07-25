Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3GYJfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:35:17 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36610 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3GYJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130724224126.GA27678@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
	<CACRpkdbOO8fFEx+PxsdJ9F1dqD6V4_RPZThvTufo9+XhhyuHOg@mail.gmail.com>
	<20130724224126.GA27678@codeaurora.org>
Date: Thu, 25 Jul 2013 11:35:10 +0200
Message-ID: <CACRpkdb6N-i5cSTSmaB9XCLT6hoYwVRRTxZvuzPw6erCD5P4SQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] MSM gpio fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:41 AM, David Brown <davidb@codeaurora.org> wrote:
> On Sat, Jul 20, 2013 at 10:54:42PM +0200, Linus Walleij wrote:

>>>   ARM: msm: Consolidate gpiomux for older architectures
>>
>> This does not look like a fix? Surely this can wait for v3.12?
>
> It fixes compilation.  But, it could also wait for v3.12.

Well it's up to you. The GPIO patch is in Torvalds tree now, so the
rest goes through ARM SoC I guess...

Yours,
Linus Walleij
