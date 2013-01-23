Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3AWMLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:11:18 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:45855 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab3AWMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:11:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUXzQgxBokwOmyx5+e8rLNCkoz6ea=YoPA7=BT+iENWj8g@mail.gmail.com>
References: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
	<CA+icZUXzQgxBokwOmyx5+e8rLNCkoz6ea=YoPA7=BT+iENWj8g@mail.gmail.com>
Date: Wed, 23 Jan 2013 13:11:15 +0100
Message-ID: <CAFTL4hzmf9ZLb4=QjpGFXT96EwOyRSFbqBD0VjLgKYaZGrBzYg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
> On Wed, Jan 23, 2013 at 12:19 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi Frederic,
>>
>> I wanted to 3.8-rc4-nohz3 [1] here on my Ubuntu/precise AMD64 system.
>>
>> Unfortunately, the build breaks like this:
>>
>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>
>
> Looks like you tested with CONFIG_KVM=y (as module fails!).

Yep. looks like I forgot some EXPORT_SYMBOL().

Thanks!
