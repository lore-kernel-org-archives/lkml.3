Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3KYWLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:11:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60248 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3KYWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:11:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nJT/P+irr6/+ZxRG0wlsF
Date: Mon, 25 Nov 2013 14:11:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] ARM: OMAP4: hwmod: add hwmod data for DES IP
Message-ID: <20131125221111.GU10023@atomide.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
 <1385415876-12387-6-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385415876-12387-6-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131125 13:45]:
> +
> +static struct omap_hwmod_addr_space omap4_des_addrs[] = {
> +	{
> +		.pa_start	= 0x480A4000,
> +		.pa_end		= 0x481A4000,
> +		.flags		= ADDR_TYPE_RT
> +	},
> +	{ }
> +};

Let's not add new address space entries. The address
space should be already coming from device tree.

Regards,

Tony
