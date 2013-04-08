Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936518Ab3DHX11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:27:27 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12800 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935496Ab3DHX1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:27:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+y8/9HIumU5K/GU9gyJlg
Date: Mon, 8 Apr 2013 16:27:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ARM: OMAP2+: Export SoC information to
 userspace using SoC infrastructure
Message-ID: <20130408232718.GE10155@atomide.com>
References: <1360842924-32429-1-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360842924-32429-1-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ruslan Bilovol <ruslan.bilovol@ti.com> [130214 03:59]:
> Hi,
> 
> This patch series is an attempt to export some OMAP SoC
> information (like name, revision etc.) to userspace.
> The first patch does some unification of OMAP SoC
> information representation in current sources.
> Second patch adds exactly needed changes using
> exists in Linux kernel SoC infrastructure.

Thanks for your patience with these patches,
applying into omap-for-v3.10/soc.

Tony
 
> -----------------------------------------
> v4:
> - Moved common part of late init into common function  in additional
>   separate patch
> - rebased on top of 'omap-for-v3.9/soc' branch of tmlind/linux-omap tree
> 
> -----------------------------------------
> v3:
> - reduced number of lines changed in the first patch (reusing
>   existent code)
> 
> -----------------------------------------
> v2:
> - changed cpu_* -> soc_* variable names
> - rebased on top of 'omap-for-v3.9/soc' branch of tmlind/linux-omap tree
> 
> 
> Ruslan Bilovol (3):
>   ARM: OMAP2+: Move common part of late init into common function
>   ARM: OMAP2+: SoC name and revision unification
>   ARM: OMAP2+: Export SoC information to userspace
> 
>  arch/arm/mach-omap2/common.h |    8 ++++
>  arch/arm/mach-omap2/id.c     |   95 ++++++++++++++++++++++++++++++++++++++----
>  arch/arm/mach-omap2/io.c     |   34 +++++++--------
>  arch/arm/plat-omap/Kconfig   |    1 +
>  4 files changed, 112 insertions(+), 26 deletions(-)
> 
> -- 
> 1.7.9.5
> 
