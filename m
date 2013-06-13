Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab3FMJzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:55:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58073 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab3FMJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:55:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+wQuZz7ac0C4DQWEzNGY94
Date: Thu, 13 Jun 2013 02:54:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 02/14] ARM: OMAP2+: AM43x: Kconfig
Message-ID: <20130613095454.GY8164@atomide.com>
References: <cover.1369658705.git.afzal@ti.com>
 <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
 <20130612171200.GL8164@atomide.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EB1DEB2@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EB1DEB2@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mohammed, Afzal <afzal@ti.com> [130613 00:04]:
> Hi Tony,
> 
> On Wed, Jun 12, 2013 at 22:42:00, Tony Lindgren wrote:
> 
> > I've updated this patch to remove the "default y" and
> > "depends on ARCH_OMAP2PLUS" entries for the usual reasons
> > and applied the first ten patches into omap-for-v3.11/soc.
> 
> Thanks.
> 
> Patch 10 "ARM: OMAP2+: AM43x: basic dt support" is missing in
> omap-for-v3.11/soc branch and omap soc pull request, can you
> please help patch 10 also to go upstream.

Hmm if that's .dts changes, Benoit needs to queue that.

Regards,

Tony
