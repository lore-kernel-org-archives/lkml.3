Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaJRRFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 13:05:06 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:64308 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaJRRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 13:05:02 -0400
Message-ID: <54429DAB.4060906@cogentembedded.com>
Date: Sat, 18 Oct 2014 21:04:43 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Balavasu <kp.balavasu@gmail.com>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: lustre: lnet: lnet: do not initialise 0
References: <20141018040330.GA23492@vasu-Inspiron-3542>
In-Reply-To: <20141018040330.GA23492@vasu-Inspiron-3542>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/18/2014 8:03 AM, Balavasu wrote:

> This patch fixes the checkpatch.pl issue
> Error:do not initialise statics to 0 or NULL

> Signed-off-by: Balavasu <kp.balavasu@gmail.com>
> ---
>   drivers/staging/lustre/lnet/lnet/router.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)

> diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
> index b5b8fb5..b6edf1f 100644
> --- a/drivers/staging/lustre/lnet/lnet/router.c
> +++ b/drivers/staging/lustre/lnet/lnet/router.c
[...]
> @@ -80,7 +80,7 @@ lnet_peer_buffer_credits(lnet_ni_t *ni)
>
>   #endif
>
> -static int check_routers_before_use = 0;
> +static int check_routers_before_use = {0};

    Eh? I thought {} is only for arrays/structures...

[...]

WBR, Sergei

