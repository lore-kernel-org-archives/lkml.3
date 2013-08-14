Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3HNFGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:06:46 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53008 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3HNFGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <520B0FCF.5080809@huawei.com>
References: <520B0FCF.5080809@huawei.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Aug 2013 22:06:24 -0700
Message-ID: <CALCETrUJTMVo4sCiVRHvVocja3Q9_hXPdc1xQ0D+EtPUT_2T7w@mail.gmail.com>
Subject: Re: [PATCH] userns: initialize the depth of user_namespace chain
To: Rui Xiang <rui.xiang@huawei.com>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:04 PM, Rui Xiang <rui.xiang@huawei.com> wrote:
> The level of init_user_ns shoule be 1.

What's wrong with zero?

--Andy

>
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
> ---
>  kernel/user.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/user.c b/kernel/user.c
> index 69b4c3d..32da187 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -48,6 +48,7 @@ struct user_namespace init_user_ns = {
>                 },
>         },
>         .count = ATOMIC_INIT(3),
> +       .level = 1,
>         .owner = GLOBAL_ROOT_UID,
>         .group = GLOBAL_ROOT_GID,
>         .proc_inum = PROC_USER_INIT_INO,
> --
> 1.8.2.2
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
