Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKUXdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:33:51 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40081 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaKUXdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:33:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18utOH4cpfkwJ4yW/loRMIe
Date: Fri, 21 Nov 2014 15:33:25 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Joachim Eastwood <manabian@gmail.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Carlos Garcia <carlos@cgarcia.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:OMAP DEVICE TREE..." <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ARM: dts: Add devicetree for NovaTech OrionLXm
Message-ID: <20141121233325.GZ7046@atomide.com>
References: <1416250957-11065-1-git-send-email-george.mccollister@gmail.com>
 <1416250957-11065-2-git-send-email-george.mccollister@gmail.com>
 <20141117190847.GA4857@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117190847.GA4857@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [141117 11:10]:
> On Mon, Nov 17, 2014 at 01:02:35PM -0600, George McCollister wrote:
> > This adds the NovaTech OrionLXm which is based on the AM335x SoC
> > http://www.novatechweb.com/substation-automation/orionlxm/
> > 
> > RAM: 512MiB
> > Flash: 4GB eMMC
> > Ethernet PHYs: 2x Micrel KSZ8041FTLI
> > USB ports are used internally by the expansion cards.
> > Internal micro SD slot is available.
> > 
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> 
> this looks might better to my eyes:
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Applying into omap-for-v3.19/dt-v2 thanks.

Tony
