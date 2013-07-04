Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3GDLsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:48:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21350 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359Ab3GDLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:48:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187fAqRBMTtuehiXnm1Q1jM
Date: Thu, 4 Jul 2013 04:48:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: grant.likely@linaro.org, linux-pm@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/6] arm: omap2plus_defconfig: enable TI bandgap
 driver
Message-ID: <20130704114811.GG5523@atomide.com>
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
 <1370637968-23299-6-git-send-email-eduardo.valentin@ti.com>
 <51C0C2A8.4020707@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C0C2A8.4020707@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduardo Valentin <eduardo.valentin@ti.com> [130618 13:33]:
> Tony,
> 
> On 07-06-2013 16:46, Eduardo Valentin wrote:
> > Enable the bandgap driver for TI SoCs thermal support.
> > 
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Cc: AnilKumar Ch <anilkumar@ti.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
> Is it possible for you to queue this one and patch 6 for 3.11?

Yes thanks applying into omap-for-v3.11/fixes.

Tony
