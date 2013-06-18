Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3FRIbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:31:44 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35602 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754417Ab3FRIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:31:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YTIYCuZIJrzUk5tbKn20Q
Date: Tue, 18 Jun 2013 01:31:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
Cc: linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: TI816X: add powerdomains for TI816x
Message-ID: <20130618083139.GF5523@atomide.com>
References: <1369926290-30404-1-git-send-email-aida.mynzhasova@skitlab.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369926290-30404-1-git-send-email-aida.mynzhasova@skitlab.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Aida Mynzhasova <aida.mynzhasova@skitlab.ru> [130530 08:10]:
> This patch adds required structures for powerdomain initialization on
> the ti816x. It is impossible to use omap3430 structures in order to
> initialize powerdomains on ti816x, because there are big differences
> between PRCM module base address offsets on these CPUs.

Thanks this looks safe for me to apply so applying to omap-for-v3.11/soc.

Regards,

Tony
