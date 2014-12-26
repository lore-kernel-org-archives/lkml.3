Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaLZBCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:02:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:40010 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLZBCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:02:34 -0500
Message-ID: <549CB39A.1050504@windriver.com>
Date: Fri, 26 Dec 2014 09:02:18 +0800
From: Ying Xue <ying.xue@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>
Subject: Re: [PATCH 1/1 net-next] tipc: replace 0 by NULL for pointers
References: <1419505550-17336-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1419505550-17336-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.163.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2014 07:05 PM, Fabian Frederick wrote:
> Fix sparse warning:
> net/tipc/link.c:1924:40: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---

Acked-by: Ying Xue <ying.xue@windriver.com>

>  net/tipc/link.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index 23bcc11..082c3b5 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -1921,7 +1921,7 @@ static struct tipc_node *tipc_link_find_owner(const char *link_name,
>  {
>  	struct tipc_link *l_ptr;
>  	struct tipc_node *n_ptr;
> -	struct tipc_node *found_node = 0;
> +	struct tipc_node *found_node = NULL;
>  	int i;
>  
>  	*bearer_id = 0;
> 

