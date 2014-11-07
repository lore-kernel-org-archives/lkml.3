Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKGQoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:44:20 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:60580 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKGQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <6654405.Rf26mgoaDJ@wuerfel>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
	<353850534.aGkkrtTogX@wuerfel>
	<20141107131129.GF18916@arm.com>
	<6654405.Rf26mgoaDJ@wuerfel>
Date: Fri, 7 Nov 2014 08:44:18 -0800
X-Google-Sender-Auth: Gl3voHo5hglEcQWA9M_1p_yTuNk
Message-ID: <CAGXu5jLBWiVieCkMFTboi5tEYw40O=-3_nH4jnMgKGQCrE6f1g@mail.gmail.com>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
From: Kees Cook <keescook@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2014 at 6:30 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 07 November 2014 13:11:30 Will Deacon wrote:
>>
>> > It's not that I care strongly about the interface, my main point is
>> > that the changelog doesn't describe why one interface was used instead
>> > the other.
>>
>> I suspect the current approach was taken because it follows the same scheme
>> as 32-bit ARM. If both methods are sufficient (Kees would have a better idea
>> than me on that), then I don't have a strong preference.
>
> Using the regset would probably address Oleg's comment, and would keep the
> implementation architecture specific. You could even share the NT_S390_SYSTEM_CALL
> number, but I don't know if there any downsides to doing that.

That's fine by me -- I only want an interface. :) I think it'd be nice
to keep it the same between arm32 and arm64, but using a specific
regset does seem to be the better approach.

-Kees

-- 
Kees Cook
Chrome OS Security
