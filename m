Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3BJCwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 21:52:32 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58069 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760956Ab3BJCwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 21:52:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Ib4wAgHtx//xlRuSNUAtL
Date: Sat, 9 Feb 2013 18:52:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: OMAP4: Add OMAP4 Blaze Tablet support
Message-ID: <20130210025225.GB4801@atomide.com>
References: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com>
 <1360352269-14922-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360352269-14922-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Ruslan Bilovol <ruslan.bilovol@ti.com> [130208 11:41]:
> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
> development platform in a tablet formfactor.
> The platform contains many of the features found in
> present-day handsets (such as audio, video, wireless
> functions and user interfaces) and in addition
> contains features for software development and test.
> 
> This patch adds initial support for the OMAP4 Blaze
> Tablet development platform. Additional functionality
> depends on different drivers and code modifications that
> are not upstreamed yet so will be added later.

Nice that you have it working, however, we're not adding
any more board-*.c files as we're moving things to device
tree based booting.

Care to try to get the basic .dts file done for this?
You will probably need to add CONFIG_ARM_APPENDED_DTB=y
and CONFIG_ARM_ATAG_DTB_COMPAT=y to omap2plus_defconfig
and append the .dtb file to zImage and run mkimage then
manually to boot it. But you should get serial and MMC
at least working to start with :)

Regards,

Tony
