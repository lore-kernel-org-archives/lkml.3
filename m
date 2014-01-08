Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaAHTHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:07:43 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39907 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbaAHTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:07:39 -0500
Message-ID: <52CDA1F7.90606@linaro.org>
Date: Wed, 08 Jan 2014 11:07:35 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Hackmann <ghackmann@google.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] timerfd: support CLOCK_BOOTTIME clock
References: <1389207423-31154-1-git-send-email-ghackmann@google.com>
In-Reply-To: <1389207423-31154-1-git-send-email-ghackmann@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:57 AM, Greg Hackmann wrote:
> Add CLOCK_BOOTTIME support to timerfd
>
> Signed-off-by: Greg Hackmann <ghackmann@google.com>
> ---
>  fs/timerfd.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 9293121..0013142 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -317,6 +317,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
>  	    (clockid != CLOCK_MONOTONIC &&
>  	     clockid != CLOCK_REALTIME &&
>  	     clockid != CLOCK_REALTIME_ALARM &&
> +	     clockid != CLOCK_BOOTTIME &&
>  	     clockid != CLOCK_BOOTTIME_ALARM))
>  		return -EINVAL;
>  

Thanks! I've already sent out my 3.14 queue to Thomas, but I'll queue
this for 3.15.

-john

