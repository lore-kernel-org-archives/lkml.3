Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaI3K1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:27:01 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44926 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaI3K0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAMo8BfJ9VJ24zsn_6VwNrAntmDqdJu11O79OyMd8eThv3UaaUw@mail.gmail.com>
References: <1407925738-26170-1-git-send-email-thierry.reding@gmail.com>
	<1407925738-26170-7-git-send-email-thierry.reding@gmail.com>
	<CAMuHMdW4emoma3nRUGna985tE17yPh5pNjMb-jxe5yc5UVr=cw@mail.gmail.com>
	<20140929085908.GI12506@ulmo>
	<CAMo8BfJ9VJ24zsn_6VwNrAntmDqdJu11O79OyMd8eThv3UaaUw@mail.gmail.com>
Date: Tue, 30 Sep 2014 14:26:20 +0400
Message-ID: <CAMo8Bf+u8er_KF4nJPSPNf9OmKZHu4y0x3Pcb7DU17y5ocBJqw@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] asm-generic/io.h: Implement generic {read,write}s*()
From: Max Filippov <jcmvbkbc@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 2:22 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> Hi Thierry,
>
>> I think this can be fixed by including linux/string.h for memset() and
>> memcpy() in include/asm-generic/io.h.
>
> Will you send that fix or do I need to do it?

Never mind, found that it's fixed in today's next.

-- 
Thanks.
-- Max
