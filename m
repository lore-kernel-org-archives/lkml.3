Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3HDUXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:23:15 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:40211 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3HDUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:23:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130804202050.GP3836@linux.vnet.ibm.com>
References: <20130727225828.GA11864@linux.vnet.ibm.com>
	<20130729153035.18805zox54aoyubf@chicago.guarana.org>
	<20130729135411.GM26694@linux.vnet.ibm.com>
	<20130730000103.35524r83mpydvs7z@chicago.guarana.org>
	<20130729142812.GN26694@linux.vnet.ibm.com>
	<CA+55aFxOp-uNHQydWfa90H+DCDvZK6d2N0fGgSNkHNrLuYWMLA@mail.gmail.com>
	<20130804202050.GP3836@linux.vnet.ibm.com>
Date: Sun, 4 Aug 2013 13:23:13 -0700
X-Google-Sender-Auth: k4jLD0Dxu-lNwx5G9HsvZ0_8nKQ
Message-ID: <CA+55aFz2mLabJTjKffYcJfWycseNUS5F=vEzmorL7QZn7SnxLQ@mail.gmail.com>
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Kevin Easton <kevin@guarana.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 1:20 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> I have it queued up for 3.12, as you say, due to "-fno-strict-overflow".
> But if you would rather have it sooner, please let me know and I will send
> a pull request.

No, that's fine. As long as it's somewhere. 3.12 is better, rc4 is
already getting too big for my taste.

              Linus
