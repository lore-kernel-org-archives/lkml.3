Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaENXSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:18:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24817 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaENXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:18:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX196DOfA60qZTeodsGOEBJBj
Date: Wed, 14 May 2014 16:18:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: nsekhar@ti.com, joelf@ti.com, linux@arm.linux.org.uk, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH v2 5/5] ARM: dts: am4372: Remove obsolete properties from
 edma node
Message-ID: <20140514231807.GD13427@atomide.com>
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com>
 <1399977032-26469-6-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399977032-26469-6-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [140513 03:31]:
> dma-channels, ti,edma-regions and ti,edma-slots no longer needed in DT since
> the the same information is available in the IP's CCCFG register.

This too:

Acked-by: Tony Lindgren <tony@atomide.com>
