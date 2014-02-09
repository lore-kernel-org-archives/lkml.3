Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBIWYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:24:10 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50853 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaBIWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:24:08 -0500
Message-ID: <1391984646.25855.79.camel@x220>
Subject: Re: [PATCH 07/28] Remove CPU_PXA988
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 23:24:06 +0100
In-Reply-To: <1391971686-9517-8-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-8-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 22:24:06.0316 (UTC) FILETIME=[A5023EC0:01CF25E5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

This one first entered the tree in v3.9, with commit 59393bb94c10
("video: mmp display subsystem"). The Kconfig symbol has not yet been
added.

>  drivers/video/mmp/Kconfig       |  2 +-
>  drivers/video/mmp/hw/Kconfig    |  2 +-
>  drivers/video/mmp/hw/mmp_ctrl.h | 32 --------------------------------
>  3 files changed, 2 insertions(+), 34 deletions(-)
> 
> [..] 
>
> diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
> index 57b03e2..95e8ec2 100644
> --- a/drivers/video/mmp/hw/Kconfig
> +++ b/drivers/video/mmp/hw/Kconfig
> @@ -2,7 +2,7 @@ if MMP_DISP
>  
>  config MMP_DISP_CONTROLLER
>  	bool "mmp display controller hw support"
> -	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
> +	depends on CPU_PXA910 || CPU_MMP2
>  	default n
>  	help
>  		Marvell MMP display hw controller support

Please also remove the reference to PXA988 in the help text. Aside from
that:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle

