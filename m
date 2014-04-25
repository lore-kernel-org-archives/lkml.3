Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaDYQ2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:28:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59101 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaDYQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:28:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19GqqtIDyKQ/sQ5gBolL6Mi
Date: Fri, 25 Apr 2014 09:27:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH v2] ARM: OMAP5: Switch to THUMB mode if needed on
 secondary CPU
Message-ID: <20140425162758.GB20807@atomide.com>
References: <1398195639-29273-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398195639-29273-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140422 12:41]:
> On my DRA7 system, when the kernel is built in Thumb-2 mode, the secondary CPU
> (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
> seems to be because the CPU is in ARM mode once the ROM hands over control to
> the kernel.  Switch to Thumb-2 mode if required once the kernel is control of
> secondary CPU. On OMAP4 on the other hand, it appears to be in Thumb-2 mode on
> entry so this is not required and SMP boot works as is.
> 
> Also corrected a spurious '+' and updated copyright information.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Tested-by: Nishanth Menon <nm@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Thanks applying into omap-for-v3.15/fixes-v2.

Tony
