Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaBIWHJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:07:09 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52146 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaBIWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:07:07 -0500
Message-ID: <1391983624.25855.70.camel@x220>
Subject: Re: [PATCH 01/28] Remove CPU_MMP3
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:USB PHY LAYER" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date: Sun, 09 Feb 2014 23:07:04 +0100
In-Reply-To: <1391971686-9517-2-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 22:07:04.0262 (UTC) FILETIME=[43D12E60:01CF25E3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

This symbol first popped up as a dependency in v3.6, through commit
3d4eb9dfa3e8 ("usb: gadget: mv: Add USB 3.0 device driver for Marvell
PXA2128 chip."). The Kconfig symbol itself was never added.

> diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
> index 02f109a..57b03e2 100644
> --- a/drivers/video/mmp/hw/Kconfig
> +++ b/drivers/video/mmp/hw/Kconfig
> @@ -2,7 +2,7 @@ if MMP_DISP
>  
>  config MMP_DISP_CONTROLLER
>  	bool "mmp display controller hw support"
> -	depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
> +	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
>  	default n
>  	help
>  		Marvell MMP display hw controller support

You should remove the reference to MMP3 in the help text (not displayed
here) too, I'd guess. Aside from that:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle

