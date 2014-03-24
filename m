Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaCXVdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:33:20 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49902 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaCXVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <532FFBDE.7030407@broadcom.com>
References: <CAK7N6vrgnNdFvo8as+DrhXurxP+SexN9gi3WFrX_SCO9i2Ybyw@mail.gmail.com>
	<532FFBDE.7030407@broadcom.com>
Date: Mon, 24 Mar 2014 14:33:18 -0700
Message-ID: <CAK7N6voRqo5fztqHLM7BLG14GNrMXPu_fpS6weue8hZU5uUJ1w@mail.gmail.com>
Subject: Re: Disabling gcc inline operation
From: anish singh <anish198519851985@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 2:33 AM, Arend van Spriel <arend@broadcom.com> wrote:
> On 23/03/14 23:31, anish singh wrote:
>>
>> Many a time i have got a crash and it is difficult
>> to find out the exact function which crashed
>> because the crash stack doesn't show the "real"
>> function because gcc inlines many functions when
>> ever it desires or when it optimizes for speed.
>>
>> So i don't want gcc to inline any function instead
>> just call the function so that i can see the crash
>> stack of each function called. I just want to do
>> this for debugging. Please let me know how can
>> i do that?
>>
>> What switch command to pass to gcc in the make
>> of linux kernel?
>
>
> You tried to look at gcc.gnu.org, right? Your best options are -O0 and/or
> -Og for debugging purposes.
It worked with -fno-inline
>
> Regards,
> Arend
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
