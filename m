Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbbA0PGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:06:46 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60131 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbbA0PGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:06:41 -0500
MIME-Version: 1.0
In-Reply-To: <1422350658.14015.9.camel@x220>
References: <1421790155-3309-1-git-send-email-john.stultz@linaro.org>
	<1422350658.14015.9.camel@x220>
Date: Tue, 27 Jan 2015 07:06:40 -0800
Message-ID: <CALAqxLVcRSNAtm_D3e-9hChaCd8EKtVMqhQwV79F=5zt2HkyOA@mail.gmail.com>
Subject: Re: [PATCH 1/2][RFC] staging: Remove the Android alarm-dev driver
From: John Stultz <john.stultz@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Hackmann <ghackmann@google.com>, Elliott Hughes <enh@google.com>,
        Todd Poynor <toddpoynor@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 1:24 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2015-01-20 at 13:42 -0800, John Stultz wrote:
>> The functionality provided by the Android alarm-dev driver
>> should now be present in the timerfd interface (thanks to
>> Greg Hackmann and Todd Poynor).
>>
>> As of Lollipop, AOSP can make use of the timerfd if
>> alarm-dev is not present (though a fixup for setting the
>> rtc time if rtc0 isn't the backing for _ALARM clockids has
>> been applied post-Lollipop).
>>
>> Thus, we should be able to remove alarm-dev from staging.
>>
>> Cc: Greg Hackmann <ghackmann@google.com>
>> Cc: Elliott Hughes <enh@google.com>
>> Cc: Todd Poynor <toddpoynor@google.com>
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>
> This became commit 5da41e925656 ("staging: Remove the Android alarm-dev
> driver") in today's linux-next (ie, next-20150127). I noticed because a
> script I use to check linux-next spotted a minor problem with it.
>
>>  drivers/staging/android/Kconfig              |   9 -
>
> Here there should have been a line reading
>    drivers/staging/android/Makefile             |   1 -


Oh grumble. You're right. I'll send a cleanup patch in.

Thanks for catching this!
-john
