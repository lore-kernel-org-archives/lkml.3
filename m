Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaGOH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:27:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52461 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932436AbaGOH1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:27:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19GdVkXid1xDXjhyoe9qfUN
Date: Tue, 15 Jul 2014 00:25:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>, Pekon Gupta <pekon@ti.com>,
        Michal Vokac <vokac.m@gmail.com>, Michal Sojka <sojkam1@fel.cvut.cz>,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH] ARM: omap2+: gpmc-nand: Use dynamic
 platform_device_alloc()
Message-ID: <20140715072544.GA28715@atomide.com>
References: <1401891875-27843-1-git-send-email-lisovy@merica.cz>
 <53BFEA6A.4020501@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BFEA6A.4020501@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140711 06:47]:
> On 06/04/2014 05:24 PM, Rostislav Lisovy wrote:
> > GPMC controller supports up to 8 memory devices connected to it.
> > Since there is one statically allocated "struct platform_device
> > gpmc_nand_device" it is not possible to configure the system to
> > use more than one NAND device connected to the GPMC. This
> > modification makes it possible to use up to 8 NAND devices
> > connected to the GPMC controller.
> > 
> > Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> 
> pushed to git@github.com:rogerq/linux.git	for-v3.17/gpmc-omap
> 
> Tony,
> 
> You can please pull all omap-gpmc patches for 3.17 from there. Thanks.

OK so just this one fix, merging into omap-for-v3.17/fixes-not-urgent.

Regards,

Tony
