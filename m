Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbbAEE2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 23:28:14 -0500
Received: from ozlabs.org ([103.22.144.67]:53535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbbAEE2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 23:28:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Elder <elder@linaro.org>, Joe Perches <joe@perches.com>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Daniel Mack <daniel@zonque.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michal Nazarewicz <mina86@mina86.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Elder <alex.elder@linaro.org>, Daniel Walter <dwalter@google.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] linux/kernel.h: merge ARRAY_AND_SIZE defines
In-Reply-To: <549AC776.8090905@linaro.org>
References: <1419399496-5955-1-git-send-email-yamada.m@jp.panasonic.com> <1419399879.6157.9.camel@perches.com> <549AC776.8090905@linaro.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 05 Jan 2015 10:08:22 +1030
Message-ID: <87sifqp15d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Elder <elder@linaro.org> writes:
> On 12/23/2014 11:44 PM, Joe Perches wrote:
>> On Wed, 2014-12-24 at 14:38 +0900, Masahiro Yamada wrote:
>>> ARRAY_AND_SIZE is a useful macro.  Its definition is already
>>> duplicated in some headers.  Move it to include/linux/kernel.h.
>> 
>> I think it's not a good/useful macro and
>> would prefer the uses expanded instead.
>
> For what it's worth, I agree.	-Alex

Me too.  It's fine in current usage, but I wouldn't want to see
more of it.

Cheers,
Rusty.
