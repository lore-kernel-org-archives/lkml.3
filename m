Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaGIKLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:11:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43719 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754242AbaGIKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:11:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Q8iVhNnrSGQdp+bx0oZKF
Date: Wed, 9 Jul 2014 03:11:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mugunthan V N <mugunthanvnm@ti.com>, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Re-send PATCH 1/1] arm: dra7xx: Add hwmod data for MDIO and CPSW
Message-ID: <20140709101116.GM28884@atomide.com>
References: <1404825399-10330-1-git-send-email-mugunthanvnm@ti.com>
 <20140709095552.GA25154@breakpoint.cc>
 <20140709100147.GB25154@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140709100147.GB25154@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <sebastian@breakpoint.cc> [140709 03:03]:
> On 2014-07-09 11:55:52 [+0200], Sebastian Andrzej Siewior wrote:
> > On 2014-07-08 18:46:39 [+0530], Mugunthan V N wrote:
> > > Adding hwmod data for CPSW and MDIO which is present in DRA7xx SoC
> > 
> > I reverted my patch, applied this one and after boot I got:
> Oh me dum dum. I had --dry-run…
> 
> Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> This is basically what Tony hasked me to do: No IRQ numbers & iomem.

OK great thanks for testing :)

Tony
