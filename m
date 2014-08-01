Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaHAXi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 19:38:29 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36327 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaHAXi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 19:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140801002017.GA2945@kroah.com>
References: <20140731170735.5cf2062b@canb.auug.org.au>
	<20140801002017.GA2945@kroah.com>
Date: Fri, 1 Aug 2014 19:38:26 -0400
X-Google-Sender-Auth: qYEvGypLuYKYlPdbPO4MImznmag
Message-ID: <CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the tip tree
From: Kees Cook <keescook@chromium.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 8:20 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Jul 31, 2014 at 05:07:35PM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the driver-core tree got a conflict in
>> lib/Kconfig.debug between commit e704f93af5a0 ("kernel: time: Add
>> udelay_test module to validate udelay") from the tip tree and commit
>> 0a8adf584759 ("test: add firmware_class loader test") from the
>> driver-core tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
> Looks good, thanks.

For keeping things regularized, could this module instead be named
"test_udelay", to match the rest of most of the test modules?
(Starting with "test_".)

-Kees

-- 
Kees Cook
Chrome OS Security
