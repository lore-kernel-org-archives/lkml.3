Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239Ab3GQXYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:24:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934200Ab3GQXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:24:44 -0400
Message-ID: <51E72752.9020206@zytor.com>
Date: Wed, 17 Jul 2013 16:22:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716004727.b60b2c96.akpm@linux-foundation.org> <20130716005611.e4ccab02.akpm@linux-foundation.org> <201307161008.07643.yann.morin.1998@free.fr> <20130716180408.GA19863@merkur.ravnborg.org> <20130717211649.GA5619@merkur.ravnborg.org> <20130717223033.GF3385@free.fr>
In-Reply-To: <20130717223033.GF3385@free.fr>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 03:30 PM, Yann E. MORIN wrote:
> 
> At the very least we'd have to decide if this is available only for
> booleans/tristates, or for any type? Your implementation seems to make
> it valid for strings/ints, too.
> 

I feel the test should *export* a boolean.

It is worth noting that one of the things that keep getting brought up
as something that need this is gcc/binutils support for a specific feature.

	-hpa


