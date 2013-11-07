Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3KGLwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:52:07 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:37392 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3KGLwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:52:03 -0500
MIME-Version: 1.0
In-Reply-To: <1383788572-25938-3-git-send-email-cody@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
	<1383788572-25938-3-git-send-email-cody@linux.vnet.ibm.com>
Date: Thu, 7 Nov 2013 03:52:01 -0800
Message-ID: <CANN689H=AEC7-KqD+iw_3v_a-W_yJagXOv3Zxk7NMwV99gm_zQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] rbtree/test: move rb_node to the middle of the
 test struct
From: Michel Lespinasse <walken@google.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        rostedt@goodmis.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 5:42 PM, Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> Avoid making the rb_node the first entry to catch some bugs around NULL
> checking the rb_node.
>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  lib/rbtree_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
> index 31dd4cc..df6c125 100644
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -8,8 +8,8 @@
>  #define CHECK_LOOPS 100
>
>  struct test_node {
> -       struct rb_node rb;
>         u32 key;
> +       struct rb_node rb;
>
>         /* following fields used for testing augmented rbtree functionality */
>         u32 val;

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
