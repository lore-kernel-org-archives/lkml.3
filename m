Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaEWOp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:45:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61634 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaEWOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:45:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Ub21OWrdVa+o8AP31wrZ+
Date: Fri, 23 May 2014 07:45:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, bcousson@baylibre.com, linux@arm.linux.org.uk,
        plagnioj@jcrosoft.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH v3 2/3] ARM: dts: oma3-gta04: Add display support
Message-ID: <20140523144533.GC2321@atomide.com>
References: <1399580212-5183-1-git-send-email-marek@goldelico.com>
 <1399580212-5183-3-git-send-email-marek@goldelico.com>
 <537F04D7.4000201@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537F04D7.4000201@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [140523 01:21]:
> On 08/05/14 23:16, Marek Belisko wrote:
> > This patch add support for lcd display on gta04 board. Display control
> > is connected to spi (used spi bitbang driver).
> > 
> > Signed-off-by: Marek Belisko <marek@goldelico.com>
> > ---
> >  arch/arm/boot/dts/omap3-gta04.dts | 87 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 87 insertions(+)
> 
> I can take this via my tree.
> 
> Tony, can I have your ack on this?

Yes for the whole series:

Acked-by: Tony Lindgren <tony@atomide.com>
