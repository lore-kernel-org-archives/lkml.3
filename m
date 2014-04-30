Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221AbaD3V4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:56:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44680 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaD3V4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:56:36 -0400
Message-ID: <53617188.9070108@kernel.dk>
Date: Wed, 30 Apr 2014 15:56:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix format string mismatch in cfq-iosched.c
References: <1398656314-19068-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398656314-19068-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 09:38 PM, Masanari Iida wrote:
> Fix format string mismatch in cfq_var_show()
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  block/cfq-iosched.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5063a0b..22dffeb 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -4460,7 +4460,7 @@ out_free:
>  static ssize_t
>  cfq_var_show(unsigned int var, char *page)
>  {
> -	return sprintf(page, "%d\n", var);
> +	return sprintf(page, "%u\n", var);
>  }
>  
>  static ssize_t

Thanks, applied.

-- 
Jens Axboe

