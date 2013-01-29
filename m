Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3A2DuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:50:12 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:44933 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A2DuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:50:10 -0500
MIME-Version: 1.0
In-Reply-To: <1a8f7aa6-f27a-4237-9be1-1b2c3718e21a@email.android.com>
References: <510579C1.3000800@zytor.com>
	<1359313804.10797.74.camel@shinybook.infradead.org>
	<51057DA7.7040907@zytor.com>
	<CAE9FiQUFZwmiBgYwsoLZ4O+f_w-V01Eb8_6L4ZrHeA4DfLJd8A@mail.gmail.com>
	<0023b092-6149-418f-8adc-dd7f5631006c@email.android.com>
	<CAE9FiQWnxQXQgjmEs+Jv=uoYHK-GuP34D1B_5NyJp6Nf6s2sYw@mail.gmail.com>
	<1a8f7aa6-f27a-4237-9be1-1b2c3718e21a@email.android.com>
Date: Mon, 28 Jan 2013 19:50:10 -0800
X-Google-Sender-Auth: xQvIDr1drGPnmW37hYJhCFTmbdE
Message-ID: <CAE9FiQXwwu7HELhNUMFTMswe=X58+0Jpc7GeEBdhiF9Jcm4o3Q@mail.gmail.com>
Subject: Re: bzImage 2.12
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 7:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Thanks.
>
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>>On Sun, Jan 27, 2013 at 11:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> I'm planning to sort it out... I'll let you know if I run out of
>>bandwidth.
>>>
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>>On Sun, Jan 27, 2013 at 11:19 AM, H. Peter Anvin <hpa@zytor.com>
>>wrote:
>>>>>
>>>>> I think we can probably do that, since it doesn't affect anything
>>>>non-broken
>>>>> at this point.  I'm sorting out what can be done for 3.8 vs 3.9 at
>>>>this
>>>>> point.
>>>>>
>>>>> Anyway, as you can tell I'm spending this weekend working for a
>>>>reason.
>>>>>
>>>>> It turns out the patch I sent out doesn't actually build.  Here is
>>an
>>>>> updated patch.  Can I get your ack for this so I can do the
>>>>appropriate
>>>>> hacks to your and Yinghai's patchsets?
>>>>
>>>>Acked-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>>Do you want to me to update my patchset on top it and resend?
>>>>
>>>>or you are going to sort it out by you self?
>>>>
>>
>>To save your some time, please check attached patch.
>>
>>It would take position of
>>
>>https://patchwork.kernel.org/patch/2035731/
>>
>>[25/35] x86, boot: Add fields to support load bzImage and ramdisk above
>>4G
>>

Did you get chance to put them into for-x86-boot?

You need to skip the first two about memmap= exactmap and reserveram ...

Thanks

Yinghai
