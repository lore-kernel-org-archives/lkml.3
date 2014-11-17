Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaKQVW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:22:59 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55452 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaKQVW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:22:58 -0500
Message-ID: <1416259376.18588.8.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/1 net-next] net/core: include linux/types.h instead of
 asm/types.h
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Date: Mon, 17 Nov 2014 13:22:56 -0800
In-Reply-To: <1416258502-9001-1-git-send-email-fabf@skynet.be>
References: <1416258502-9001-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 22:08 +0100, Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  net/core/link_watch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index bd0767e..49a9e3e 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -21,7 +21,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
>  #include <linux/bitops.h>
> -#include <asm/types.h>
> +#include <linux/types.h>
>  

We have 99 such occurrences in net/

Are you going to send 99 patches ?


