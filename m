Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaHAIXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:23:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27953 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaHAIXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:23:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/UychB0mfOsw3aQEXyvUZA
Date: Fri, 1 Aug 2014 01:21:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jeremy Vial <jvial@adeneo-embedded.com>
Cc: linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Manage OMAP34xx ES3.1.2 rev to resume from suspend
Message-ID: <20140801082140.GA26699@atomide.com>
References: <1406812234-23163-1-git-send-email-jvial@adeneo-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406812234-23163-1-git-send-email-jvial@adeneo-embedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Vial <jvial@adeneo-embedded.com> [140731 06:16]:
> Hi,
> 
> My kernel crashed when my OMAP34xx ES3.1.2 leave suspend mode. The first
> patch seems to solve the issue, and the second one corrects Linux kernel
> coding style problems.
> 
> Jeremy Vial (2):
>   ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX
>     rev3.1.2 case.
>   ARM: OMAP3: Fix coding style problems in
>     arch/arm/mach-omap2/control.c
> 
>  arch/arm/mach-omap2/control.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks applying these fixes for the merge window. I've tagged
the first patch also for stable.

Regards,

Tony
