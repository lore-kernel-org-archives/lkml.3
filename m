Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3LTTq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:46:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3LTTq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:46:58 -0500
Date: Fri, 20 Dec 2013 20:46:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>
cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com
Subject: Re: [PATCH] [trivial] scsi: Fix typo in gdth_ioctl.h
In-Reply-To: <1387472534-13458-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.LNX.2.00.1312202046240.11949@pobox.suse.cz>
References: <1387472534-13458-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Masanari Iida wrote:

> Correct structure name typo "drvers" to "drivers"
> in gdth_ioctl.h
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/scsi/gdth_ioctl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/gdth_ioctl.h b/drivers/scsi/gdth_ioctl.h
> index b004c61..047295a9 100644
> --- a/drivers/scsi/gdth_ioctl.h
> +++ b/drivers/scsi/gdth_ioctl.h
> @@ -229,7 +229,7 @@ typedef struct {
>          } general;
>          struct {
>              u16          version;            /* driver version */
> -        } drvers;
> +        } drivers;

This is incorrect -- drvers stands for driver version here.

-- 
Jiri Kosina
SUSE Labs
