Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaGULLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:11:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22149 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaGULLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:11:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19F5FgTKIA2bYqFCA5HYdWJ
Date: Mon, 21 Jul 2014 04:10:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ARM: OMAP2+: timer: Add fallback for of_clk_get
Message-ID: <20140721111019.GZ18374@atomide.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
 <1398216429-4681-8-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398216429-4681-8-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140422 18:27]:
> Not all platforms currently will support of_clk_get on timer
> because they may not have clock property in their DT nodes. Add
> code to handle this case so that things are kept working. Finally
> we can delete this code once all system timer nodes have a clock
> property.

I think this needs updating now too? Might be best to fix the
platforms that don't have clocks available yet via DT instead :)

Regards,

Tony
