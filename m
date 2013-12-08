Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3LHTIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 14:08:38 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:21915 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab3LHTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 14:08:37 -0500
Message-ID: <1386529714.9478.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/mqueue.c: fixed a brace coding style issue
From: Davidlohr Bueso <davidlohr@hp.com>
To: Roman Kuznetsov <kuznetsov24@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 08 Dec 2013 11:08:34 -0800
In-Reply-To: <1386444026-14771-1-git-send-email-kuznetsov24@gmail.com>
References: <1386444026-14771-1-git-send-email-kuznetsov24@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 23:20 +0400, Roman Kuznetsov wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Roman Kuznetsov <kuznetsov24@gmail.com>

Ok, fine.

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

> ---
>  ipc/mqueue.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 95827ce..9346238 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -1303,11 +1303,10 @@ retry:
>  out_fput:
>  	fdput(f);
>  out:
> -	if (sock) {
> +	if (sock)
>  		netlink_detachskb(sock, nc);
> -	} else if (nc) {
> +	else if (nc)
>  		dev_kfree_skb(nc);
> -	}
>  	return ret;
>  }
>  


