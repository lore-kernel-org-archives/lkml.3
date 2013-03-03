Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3CCIfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 03:35:31 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4976 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3CCIfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 03:35:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: [PATCH 04/14] MAINTAINERS: fix drivers/media/i2c/cx2341x.c
Date: Sun, 3 Mar 2013 09:35:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net> <1362275632-20242-5-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1362275632-20242-5-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303030935.17634.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun March 3 2013 02:53:42 Cesar Eduardo Barros wrote:
> This file was moved to drivers/media/common/ by commit 6259582 ([media]
> cx2341x: move from media/i2c to media/common).
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5af82f9..261b245 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2286,7 +2286,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  W:	http://linuxtv.org
>  S:	Maintained
> -F:	drivers/media/i2c/cx2341x*
> +F:	drivers/media/common/cx2341x*
>  F:	include/media/cx2341x*
>  
>  CX88 VIDEO4LINUX DRIVER
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks! I completely forgot to update this when I moved the file.

Regards,

	Hans
