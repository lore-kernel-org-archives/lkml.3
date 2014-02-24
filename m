Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaBXTuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:50:06 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42620 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaBXTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:50:05 -0500
Message-ID: <530BA26A.5070603@linaro.org>
Date: Mon, 24 Feb 2014 11:50:02 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] [RFC] time: Improve negative offset handling in timekeeping_inject_offset
References: <1393019430-13200-1-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de> <CALAqxLUJYT9G2ekEk_BoNNL4T6Pjiq56KR_i87GLnSuyddWS0Q@mail.gmail.com> <alpine.DEB.2.02.1402221058010.21251@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402221058010.21251@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 02:01 AM, Thomas Gleixner wrote:
> On Fri, 21 Feb 2014, John Stultz wrote:
>> But yes, we can just leave it as is, and it is a bit academic. But
> To be honest, I was mostly arguing due to the academic nature. :)
>
> The important point is that we restrict it to -1e9 < tv_nsec <
> 1e9. The signed/unsigned combos are not that interesting as long as
> our internal helpers cope nicely with that.

And for this patch it does check abs(tv_nsec) is sane.

I still think the patch is a good idea, so I'll submit it again after
further testing. But if folks object, then I'll drop it.

thanks
-john

