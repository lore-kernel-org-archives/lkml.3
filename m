Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaLAVre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:47:34 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48657 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaLAVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:47:32 -0500
From: Paul Moore <paul@paul-moore.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: sds@tycho.nsa.gov, james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com
Subject: Re: [PATCH] selinux: Remove security_ops extern
Date: Mon, 01 Dec 2014 16:47:29 -0500
Message-ID: <2400532.lYxijS5ODp@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1417148735-13522-1-git-send-email-yaodongdong@huawei.com>
References: <1417148735-13522-1-git-send-email-yaodongdong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 28, 2014 04:25:35 AM Yao Dongdong wrote:
> security_ops is not used in this file.
> 
> Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
> ---
>  security/selinux/hooks.c | 2 --
>  1 file changed, 2 deletions(-)

Applied, thanks.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c603b20..6da7532 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -95,8 +95,6 @@
>  #include "audit.h"
>  #include "avc_ss.h"
> 
> -extern struct security_operations *security_ops;
> -
>  /* SECMARK reference count */
>  static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);

-- 
paul moore
www.paul-moore.com

