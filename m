Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3E3Q4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:56:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3E3Q4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:56:18 -0400
Message-ID: <51A78478.6040704@infradead.org>
Date: Thu, 30 May 2013 09:55:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
References: <1369925065-16604-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1369925065-16604-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/13 07:44, Masanari Iida wrote:
> Correct spelling typo in printk within various part of drivers.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/acpi/acpica/utobject.c                 | 2 +-
>  drivers/cpufreq/s3c2416-cpufreq.c              | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c      | 2 +-
>  drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
>  drivers/net/wireless/ath/ath9k/Kconfig         | 2 +-
>  drivers/scsi/libiscsi_tcp.c                    | 2 +-
>  drivers/scsi/pmcraid.c                         | 2 +-
>  lib/Kconfig.kgdb                               | 2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> index 140e878..e00037f 100644
> --- a/lib/Kconfig.kgdb
> +++ b/lib/Kconfig.kgdb
> @@ -64,7 +64,7 @@ config KGDB_LOW_LEVEL_TRAP
>         default n
>         help
>           This will add an extra call back to kgdb for the breakpoint
> -         exception handler on which will will allow kgdb to step
> +         exception handler on which will allow kgdb to step

	    exception handler which will allow kgdb to step

>           through a notify handler.
>  
>  config KGDB_KDB
> 


-- 
~Randy
