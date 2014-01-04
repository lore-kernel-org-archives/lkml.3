Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaADA2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:28:37 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50101 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaADA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:28:36 -0500
Message-ID: <52C755AF.5030402@linaro.org>
Date: Fri, 03 Jan 2014 16:28:31 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] seqlock: Use raw_ prefix instead of _no_lockdep
References: <52C5E675.80701@linaro.org>	<1388704274-5278-1-git-send-email-john.stultz@linaro.org> <CA+55aFxv8wTRifZ9iHn-tCfUqwpJZmLiF7QU=Pc6dVa8QnTyCQ@mail.gmail.com>
In-Reply-To: <CA+55aFxv8wTRifZ9iHn-tCfUqwpJZmLiF7QU=Pc6dVa8QnTyCQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 04:50 PM, Linus Torvalds wrote:
> On Thu, Jan 2, 2014 at 3:11 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Linus disliked the _no_lockdep() naming, so instead
>> use the more-consistent raw_* prefix to the non-lockdep
>> enabled seqcount methods.
>>
>> This also adds raw_ methods for the write operations
>> as well, which will be utilized in a following patch.
> Ack on this and on 2/2. I'm assuming I'll get them through the -tip
> tree, which is where the problem came from. No?

It seems Peter or Ingo are still on holiday. Hopefully they will be back
on Monday to queue these.

thanks
-john
