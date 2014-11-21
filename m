Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaKUURW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:17:22 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35812 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaKUURT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <2946373.UZAWO9ynEM@wuerfel>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
	<CALAqxLVRJKHiZVr2_gW-uos-LtW5iQLs-qOWUedfWp70f9iHDw@mail.gmail.com>
	<2946373.UZAWO9ynEM@wuerfel>
Date: Fri, 21 Nov 2014 12:17:18 -0800
Message-ID: <CALAqxLXTj3td4suOUm8XM7fbbLwzAAG5FKz+WsiePewU+Qv3og@mail.gmail.com>
Subject: Re: [PATCH 00/12]
From: John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 12:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 21 November 2014 11:53:04 John Stultz wrote:
>> On Fri, Nov 21, 2014 at 11:44 AM, John Stultz <john.stultz@linaro.org> wrote:
>> > Hey Thomas, All,
>> >
>> > Just wanted to submit a handful of changes for 3.19
>> >
>> > * udelay_test/test_udelay consistent file naming
>> > * Time / ntp edge-case fixes from Xunlei
>> > * y2038-safe internal interfaces from Xunlei and me
>> > * Celanup suspend/resume timing y2038 issues
>> > * Remove y2038 unsafe inject_sleeptime inteface
>> >
>> > Just as an FYI, I'm trying out signing this tag with
>> > a new subkey on my yubikey. Hopefully haven't mucked
>> > it up.
>
> Hmm, patch 1 doesn't seem to have made it to the list.

I suspect its just I didn't CC you on that one (it already had a long
cc list from the last time I sent it around for 3.17). I do see it in
my list archive.

> Can you send that again?

Given I forgot the subject for the cover-letter and then managed to
hit send before writing my apology for that, I'm going to give it a
rest for today. :)

Thomas has pointed out one other typo issue in one of the patches so
I've already updated it. If he doesn't pull that in, or if there are
any other objections I'll rework and resend on Monday.

thanks
-john
