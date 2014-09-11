Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaIKXun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:50:43 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:64682 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaIKXum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <5412327B.6030000@lwfinger.net>
References: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
	<5412327B.6030000@lwfinger.net>
Date: Thu, 11 Sep 2014 16:50:41 -0700
X-Google-Sender-Auth: 1fZjUOLIb3Ld2n2xup_au0xTD30
Message-ID: <CAGXu5jJmyyWrsS2EFPT59RjK-np3sqmxe69meecmpicv6BNKrA@mail.gmail.com>
Subject: Re: repeated bugs in new rtl wifi drivers
From: Kees Cook <keescook@chromium.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 4:38 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/11/2014 05:27 PM, Kees Cook wrote:
>>
>> Hi,
>>
>> I keep fixing this same bug that keeps showing up in the rtl wifi
>> drivers. CL_PRINTF keeps getting redefined (incorrectly) instead of
>> using a correctly fixed global. Is there a way to stop this from
>> happening again?
>>
>> Here are the past three (identical) fixes I've landed:
>> a3355a62673e2c4bd8617d2f07c8edee92a89b8d
>> 037526f1ae7eeff5cf27ad790ebfe30303eeebe8
>> 6437f51ec36af8ef1e3e2659439b35c37e5498e2
>>
>> And the buildbot report below seems to show there are more to be made. :)
>
>
> Sorry that I missed your fix. I should have seen it come through Linville's
> list. I will push your fix through again.

Well, I should clarify: it's not getting unfixed/reverted, but rather,
it hasn't been consolidated to avoid needing the code again in the
future. All three of the fixes above are on almost identical header
files. If we could consolidate them, that would be great, and it would
keep things much nicer.

>
> We are in the process of unifying the in-house driver development at Realtek
> with what I have been doing in the kernel. Unfortunately, this will involve
> rather massive changes in all the codes. I am trying not to wipe out fixes
> such as this one, but I expect that others will slip through. Once this
> painful process is completed, maintaining the drivers should be a lot
> easier.

Good to hear! :) Thanks for working on this!

-Kees

-- 
Kees Cook
Chrome OS Security
