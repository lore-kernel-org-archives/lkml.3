Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3GPKFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:05:24 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57177 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3GPKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130716095938.GA4962@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <201307161132.39845.yann.morin.1998@free.fr> <20130716093820.GE4402@pd.tnic>
 <201307161145.27810.yann.morin.1998@free.fr> <20130716095938.GA4962@pd.tnic>
From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 16 Jul 2013 11:04:41 +0100
X-Google-Sender-Auth: x9ykn2S6vkir87mCZRPKjXOoelw
Message-ID: <CAGVrzcbJrhmxCHqZOhSZH9FeTNj_x674+CSBS0bSRaKDk3nRLA@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
To: Borislav Petkov <bp@alien8.de>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com,
        Andy Lee <raphael.andy.lee@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/16 Borislav Petkov <bp@alien8.de>:
> On Tue, Jul 16, 2013 at 11:45:27AM +0200, Yann E. MORIN wrote:
>> As discussed with Florian in this thread, either one of:
>>   - a warning at check time
>>   - a comment in Kconfig
>
> Whatever you do, make sure to make it quite clear to users what she
> needs to do.
>
> What I really have a problem with is options being hidden just because I
> haven't selected something they depend on and having to run around the
> Kconfig maze to find what I also need to select in order for the option
> to appear.

Yes, me too, which is why I suggested the warning, as in "a warning
printed to stdout/stderr" rather than a Kconfig comment which will be
easy to be ignored.
--
Florian
