Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3LQAsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:48:50 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:55254 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3LQAst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:48:49 -0500
Message-ID: <52AF9F68.8050300@elopez.com.ar>
Date: Mon, 16 Dec 2013 21:48:40 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: trivial@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo in DEVTMPFS_MOUNT help text
References: <1385992779-15544-1-git-send-email-emilio@elopez.com.ar>
In-Reply-To: <1385992779-15544-1-git-send-email-emilio@elopez.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 02/12/13 10:59, Emilio López escribió:
> rootfs was missing its f.
>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
>   drivers/base/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index e373671..ec36e77 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -49,7 +49,7 @@ config DEVTMPFS_MOUNT
>   	  with the commandline parameter: devtmpfs.mount=0|1.
>   	  This option does not affect initramfs based booting, here
>   	  the devtmpfs filesystem always needs to be mounted manually
> -	  after the roots is mounted.
> +	  after the rootfs is mounted.
>   	  With this option enabled, it allows to bring up a system in
>   	  rescue mode with init=/bin/sh, even when the /dev directory
>   	  on the rootfs is completely empty.
>

ping
