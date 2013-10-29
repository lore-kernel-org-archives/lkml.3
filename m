Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3J2U7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:59:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18488 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752803Ab3J2U7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:59:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+X8JPv7BO24rwlUb7Gmcc8
Date: Tue, 29 Oct 2013 13:59:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv3 6/8] ARM: dts: OMAP4: Add hwspinlock node
Message-ID: <20131029205935.GG15154@atomide.com>
References: <1381439735-52888-1-git-send-email-s-anna@ti.com>
 <1381439735-52888-7-git-send-email-s-anna@ti.com>
 <20131011234125.GG29913@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011234125.GG29913@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131011 16:49]:
> * Suman Anna <s-anna@ti.com> [131010 14:24]:
> > Add the hwspinlock device tree node for OMAP4 family
> > of SoCs.
> 
> Suman, can you please post the .dts changes separately from
> the driver changes next time so driver maintainers don't
> accidentally pick them up. That leads to unnecessary merge
> conflicts with the .dts files.

Actually I'll pick patches 6 - 8 of this series into
omap-for-v3.13/dt branch as that fixes some boot time warnings
we're seeing without them.

Regards,

Tony
