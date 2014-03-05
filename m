Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaCETvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:51:02 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27221 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755592AbaCETu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:50:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19zREo6DAtFjQ8lieNdTjAN
Date: Wed, 5 Mar 2014 11:50:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, linux@arm.linux.org.uk, akpm@linux-foundation.org,
        nm@ti.com, balajitk@ti.com, r.sricharan@ti.com,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND Patch 0/9] dts pending patches for TI omap
Message-ID: <20140305195053.GG7599@atomide.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [140303 06:53]:
> Benoit/Tony
> 
> Here I am send all the pending dt patches that can go into 3.15 merge window,
> all the patches were already posted to mailing list and has beed reviewed.
> 
> I have rebased the patches on top of
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git omap-for-v3.15/dt
> and fixed all the merge conflicts.
> 
> Pasting the mail archive for the patches series
> 
> * Add ABB device nodes
> http://linux-kernel.2935.n7.nabble.com/PATCH-0-4-ARM-dts-OMAP3630-Add-ABB-device-nodes-td794852.html
> 
> * MMC hot plug support
> http://mail.blameitonlove.com/lists/linux-omap/msg101933.html
> Dropped [PATCH 2/3] ARM: dts: am335x-evmsk: add SD card hotplug support as this
> is already merged with commit id 29ea5efb0bb612d352aa360de26e2095cb230e4a
> 
> * DRA7 Cross bar DTS patches
> Cross bar driver has been pulled for next merge, so the dts patches can also
> be pulled for next merge window.
> 
> Here is the pull request for the same patch series.
> 
> The following changes since commit f777ba1780584b100ab9664cc06d04f3bb273a84:
> 
>   Merge tag 'for_3.15/dts_signed' of git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt into omap-for-v3.15/dt (2014-03-02 14:22:03 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git omapdt-for-3.15
> 
> for you to fetch changes up to 5f78b45aa45c5b2c4de895c3b0740fda4684dae4:
> 
>   ARM: DTS: DRA7: Add routable-irqs property for gic node (2014-03-03 19:53:25 +0530)

Thanks applying all except for the crossbar ones into
omap-for-v3.15/dt.

Please resend the last three patches once the dependencies
are merged to mainline kernel as otherwise the interrupt
nubers are all wrong without the crossbar driver related
code.

Regards,

Tony
