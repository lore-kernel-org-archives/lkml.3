Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3HDTQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 15:16:06 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:33307 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3HDTQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 15:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130729142812.GN26694@linux.vnet.ibm.com>
References: <20130727225828.GA11864@linux.vnet.ibm.com>
	<20130729153035.18805zox54aoyubf@chicago.guarana.org>
	<20130729135411.GM26694@linux.vnet.ibm.com>
	<20130730000103.35524r83mpydvs7z@chicago.guarana.org>
	<20130729142812.GN26694@linux.vnet.ibm.com>
Date: Sun, 4 Aug 2013 12:16:02 -0700
X-Google-Sender-Auth: 0eHHpXlFPvLcisK8jhW-QejMmgM
Message-ID: <CA+55aFxOp-uNHQydWfa90H+DCDvZK6d2N0fGgSNkHNrLuYWMLA@mail.gmail.com>
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

On Mon, Jul 29, 2013 at 7:28 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> Ahh, there's an error in the commit message (it says signed to unsigned).
>
> Good catch, fixed!

.. so I ended up waiting for that fixed version due to this email, but
it never came. Should I just apply the original and re-fix it myself?
Or is this queued up for 3.12 as being "not likely to actually
matter", which is quite possibly true (since we compile with
"-fno-strict-overflow", and thus gcc should hopefully not ever do any
transformations that depend on signed integer overflows being
undefined)

                   Linus
