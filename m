Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKKAD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:03:29 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26894 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaKKAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:03:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3N+rA2aiLPUwgdSJj73pA
Date: Mon, 10 Nov 2014 16:02:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 0/2] ARM: OMAP4+: PM: centralize static dependency
 mapping table
Message-ID: <20141111000243.GI31454@atomide.com>
References: <1413922949-22300-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413922949-22300-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141021 13:23]:
> Hi,
> 
> This is a small step towards getting rid of static dependency logic
> from mach-omap2. As part of this, we split the list of static dep
> map from the function implementing it. This should eventually aid in
> helping remove the tables from the kernel to the device tree at a
> later point in time of cleanup.
> 
> Series based on v3.18-rc1 and could be a 3.19-rc1 material.

Applying into omap-for-3.19/soc thanks.

Tony
