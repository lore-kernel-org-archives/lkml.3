Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3A0Tjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:39:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33781 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab3A0Tjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:39:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUFZwmiBgYwsoLZ4O+f_w-V01Eb8_6L4ZrHeA4DfLJd8A@mail.gmail.com>
References: <510579C1.3000800@zytor.com> <1359313804.10797.74.camel@shinybook.infradead.org> <51057DA7.7040907@zytor.com> <CAE9FiQUFZwmiBgYwsoLZ4O+f_w-V01Eb8_6L4ZrHeA4DfLJd8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: bzImage 2.12
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 27 Jan 2013 11:39:13 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <0023b092-6149-418f-8adc-dd7f5631006c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm planning to sort it out... I'll let you know if I run out of bandwidth.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Sun, Jan 27, 2013 at 11:19 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I think we can probably do that, since it doesn't affect anything
>non-broken
>> at this point.  I'm sorting out what can be done for 3.8 vs 3.9 at
>this
>> point.
>>
>> Anyway, as you can tell I'm spending this weekend working for a
>reason.
>>
>> It turns out the patch I sent out doesn't actually build.  Here is an
>> updated patch.  Can I get your ack for this so I can do the
>appropriate
>> hacks to your and Yinghai's patchsets?
>
>Acked-by: Yinghai Lu <yinghai@kernel.org>
>
>Do you want to me to update my patchset on top it and resend?
>
>or you are going to sort it out by you self?
>
>Thanks
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
