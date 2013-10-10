Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3JJEpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:45:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63206 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3JJEpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:45:19 -0400
Message-ID: <525630DB.4030906@linaro.org>
Date: Wed, 09 Oct 2013 21:45:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] More timekeeping items for 3.13
References: <5256285F.7060705@linaro.org> <20131010043049.GA22519@gmail.com>
In-Reply-To: <20131010043049.GA22519@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 09:30 PM, Ingo Molnar wrote:
> Pulled into tip:timers/core, thanks John!
>
> One small detail I noticed, in commit 07783397c:
>
>     Cc: Linus Walleij <linus.walleij@linaro.org>
>     Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Please remove the Cc: line in such cases in the future.

Ah, yes. I'll try to be more careful about that. Sorry!

-john
