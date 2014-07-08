Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaGHQ3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:29:06 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:62823 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <539FBD10.6080909@roeck-us.net>
References: <1402770860-4504-1-git-send-email-xerofoify@gmail.com>
	<539FBD10.6080909@roeck-us.net>
Date: Tue, 8 Jul 2014 12:29:03 -0400
Message-ID: <CAPDOMVg-kAuQE_9G0yxKMwTs45gVsiQVfSxRwqtjqm2ROozcpw@mail.gmail.com>
Subject: Fwd: [PATCH] Fix comments in rbtree.c
From: Nick Krause <xerofoify@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, cody@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, sjenning@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck  wrote on Mon, Jun 16, 2014 at 11:59 PM
Subject: Re: [PATCH] Fix comments in rbtree.c
To: Nick <xerofoify@gmail.com>, cody@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
linux-kernel@vger.kernel.org


On 06/14/2014 11:34 AM, Nick wrote:
>
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
>                                  *      / \          / \
>                                  *     p   u  -->   P   U
>                                  *    /            /
> -                                *   n            N
> +                                *   n            n


You'll need a lengthy explanation here. What makes you think that the comment
is wrong ?

Guenter


This seems right as  of rereading my patch I sent to you. You can drop
this patch.
Cheers Nick
