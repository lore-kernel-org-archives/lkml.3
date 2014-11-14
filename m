Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161764AbaKNSd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:33:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54806 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161259AbaKNSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:33:57 -0500
Date: Fri, 14 Nov 2014 10:33:55 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: frowand.list@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
Message-ID: <20141114183355.GC11808@codeaurora.org>
References: <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com>
 <5461150B.2010907@codeaurora.org>
 <54616CB3.5000405@gmail.com>
 <54616F74.5010408@codeaurora.org>
 <54618077.9000108@gmail.com>
 <5463A381.9060305@gmail.com>
 <5465072F.6040509@codeaurora.org>
 <546550FF.2080409@gmail.com>
 <54655409.6030604@codeaurora.org>
 <7htx217k5n.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7htx217k5n.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Kevin Hilman wrote:
> 
> Due to the length of the thread, I haven't followed all the details, and
> I suspect Greg hasn't either, so I'm not sure if you're discssuing what
> the right fix is for what's in -next (still broken[1], or what should be done
> with the device board files.
> 
> If the fix from earlier in this thread is still the right one for fixing
> -next, could you repost it separately for Greg to queue/squash and for
> me to re-test (if needed.)
> 

No problem. I'll pick up your tested-by and resend.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
