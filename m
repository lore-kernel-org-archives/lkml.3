Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaHDS1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:27:07 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56357 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
References: <20140731170735.5cf2062b@canb.auug.org.au>
	<20140801002017.GA2945@kroah.com>
	<CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
Date: Mon, 4 Aug 2014 11:27:03 -0700
Message-ID: <CALAqxLUgeyn6MobUQ=wrQRBjfBPF7OHTSxJuSsYeYKC-U2KMGA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip tree
From: John Stultz <john.stultz@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 4:38 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 31, 2014 at 8:20 PM, Greg KH <greg@kroah.com> wrote:
>> On Thu, Jul 31, 2014 at 05:07:35PM +1000, Stephen Rothwell wrote:
>>> Hi Greg,
>>>
>>> Today's linux-next merge of the driver-core tree got a conflict in
>>> lib/Kconfig.debug between commit e704f93af5a0 ("kernel: time: Add
>>> udelay_test module to validate udelay") from the tip tree and commit
>>> 0a8adf584759 ("test: add firmware_class loader test") from the
>>> driver-core tree.
>>>
>>> I fixed it up (see below) and can carry the fix as necessary (no action
>>> is required).
>>
>> Looks good, thanks.
>
> For keeping things regularized, could this module instead be named
> "test_udelay", to match the rest of most of the test modules?
> (Starting with "test_".)

Sure. I'll spin up a patch to change it and will submit here shortly.

thanks
-john
