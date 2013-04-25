Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3DYMuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:50:01 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:54120 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3DYMuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130425091428.GD4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdbf03ajQaYujGfimHE+hDVjNLycE3J9Q-W-tzN2EX0fkQ@mail.gmail.com>
	<20130425091428.GD4623@gmail.com>
Date: Thu, 25 Apr 2013 14:49:59 +0200
Message-ID: <CACRpkdaeuK0p2SynenQjght9fCzTTJpt+S7hGC6d6ahPHAA7Hw@mail.gmail.com>
Subject: Re: [PATCH 09/32] ARM: ux500: Remove unused 'data_width' attributes
 from SDI DMA configs
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 11:14 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Apr 2013, Linus Walleij wrote:
>
>> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > DMA configuration data is now allocated in the MMCI driver, so these
>> > are just ignored.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I tried just applying this (since it's pretty stand-alone) but seems to
>> be dependent on things not yet in Torvalds tree so lets keep it in this
>> series then...
>
> Ideally I'd like to keep them all in the same branch, as it may lead
> to confusion/conflicts later down the line (I'm still coding a lot of
> this stuff).
>
> Naturally, I'll go with whatever you think is best, but this is my
> preference.

This works find for now, I just want the DT changes kept separately
because I'm in hell with these right now and don't want to end up
there again next merge cycle.

Yours,
Linus Walleij
