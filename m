Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaBUXRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:17:36 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24517 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbaBUXRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:17:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hysKRez0CjrkTdpDfWJ5R
Date: Fri, 21 Feb 2014 15:17:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: linux@arm.linux.org.uk, nm@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 1/1] ARM: OMAP: Kill warning in CPUIDLE code with
 !CONFIG_SMP
Message-ID: <20140221231714.GC5342@atomide.com>
References: <1392623575-4884-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392623575-4884-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [140216 23:56]:
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> for non SMP build, NR_CPUS is 1 and hence the code complains with below
> warnings.
> 
> arch/arm/mach-omap2/cpuidle44xx.c:207:8: warning: array subscript is above array bounds [-Warray-bounds]
> arch/arm/mach-omap2/cpuidle44xx.c:212:11: warning: array subscript is above array bounds [-Warray-bounds]
> 
> Kill it by making array size fixed.
> 
> Acked-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>

Thanks applying into omap-for-v3.14/fixes.

Tony
