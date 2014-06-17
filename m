Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaFQD7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:59:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61338 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbaFQD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:59:21 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539FBD10.6080909@roeck-us.net>
Date: Mon, 16 Jun 2014 20:59:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>, cody@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix comments in rbtree.c
References: <1402770860-4504-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402770860-4504-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2014 11:34 AM, Nick wrote:
> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>   lib/rbtree.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/lib/rbtree.c b/lib/rbtree.c
> index 65f4eff..c66370c 100644
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -101,11 +101,10 @@ __rb_insert(struct rb_node *node, struct rb_root *root,
>   				 *      / \          / \
>   				 *     p   u  -->   P   U
>   				 *    /            /
> -				 *   n            N
> +				 *   n            n

You'll need a lengthy explanation here. What makes you think that the comment
is wrong ?

Guenter

