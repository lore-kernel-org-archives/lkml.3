Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab3BNUyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:54:38 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39163 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001Ab3BNUye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <1352823515-6938-1-git-send-email-s.syam@samsung.com>
References: <1352823515-6938-1-git-send-email-s.syam@samsung.com>
Date: Fri, 15 Feb 2013 02:24:32 +0530
Message-ID: <CAFBvHierxkZ0WTcsgJvkrnEJGthFcLtYUb37p-nx45NRoGkF-g@mail.gmail.com>
Subject: Re: [PATCH 3/3] proc_devtree: Replace include linux/module.h with linux/export.h
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 13, 2012 at 9:48 PM, Syam Sidhardhan <syamsidhardh@gmail.com> wrote:
> Since it uses only THIS_MODULE macro, include <linux/export.h>
> is the right to go here.
>
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
>  fs/proc/proc_devtree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> index df7dd08..0e9df31 100644
> --- a/fs/proc/proc_devtree.c
> +++ b/fs/proc/proc_devtree.c
> @@ -11,7 +11,7 @@
>  #include <linux/stat.h>
>  #include <linux/string.h>
>  #include <linux/of.h>
> -#include <linux/module.h>
> +#include <linux/export.h>
>  #include <linux/slab.h>
>  #include <asm/prom.h>
>  #include <asm/uaccess.h>

ping..

Thanks,
Syam.
