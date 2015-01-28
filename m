Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbbA1UPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:15:36 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49406 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbbA1UPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <1422470138-8352-1-git-send-email-mpa@pengutronix.de>
References: <1422470138-8352-1-git-send-email-mpa@pengutronix.de>
Date: Wed, 28 Jan 2015 14:12:02 -0500
Message-ID: <CAECXXi7whHm3uUJP_yXddnSSTikd_p-z2Eq=85wqe1HB9bL_Pg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update NBD maintainer
From: Paul Clements <paul.clements@us.sios.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small typo, but otherwise, I approve.

On Wed, Jan 28, 2015 at 1:35 PM, Markus Pargmann <mpa@pengutronix.de> wrote:
> Paul stops maintining NBD and I will take his place from now on.
>
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2ebb056cbe0a..4a83259e7f45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6583,9 +6583,10 @@ F:       include/uapi/linux/netrom.h
>  F:     net/netrom/
>
>  NETWORK BLOCK DEVICE (NBD)
> -M:     Paul Clements <Paul.Clements@steeleye.com>
> +M:     Markus Pargmann <mpa@pengutronix.de

^^ here, missing the trailing >

>  S:     Maintained
>  L:     nbd-general@lists.sourceforge.net
> +T:     git git://git.pengutronix.de/git/mpa/linux-nbd.git
>  F:     Documentation/blockdev/nbd.txt
>  F:     drivers/block/nbd.c
>  F:     include/linux/nbd.h
> --
> 2.1.4
