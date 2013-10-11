Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3JKXle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:41:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14910 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383Ab3JKXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:41:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KUumnNk1ZiGDY+WUWiJNC
Date: Fri, 11 Oct 2013 16:41:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv3 6/8] ARM: dts: OMAP4: Add hwspinlock node
Message-ID: <20131011234125.GG29913@atomide.com>
References: <1381439735-52888-1-git-send-email-s-anna@ti.com>
 <1381439735-52888-7-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381439735-52888-7-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [131010 14:24]:
> Add the hwspinlock device tree node for OMAP4 family
> of SoCs.

Suman, can you please post the .dts changes separately from
the driver changes next time so driver maintainers don't
accidentally pick them up. That leads to unnecessary merge
conflicts with the .dts files.

Thanks,

Tony
