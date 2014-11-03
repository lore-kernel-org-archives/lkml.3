Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaKCSOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:14:34 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52399 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaKCSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:14:32 -0500
Date: Mon, 3 Nov 2014 10:14:28 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/irq: Drop obsolete 'interrupts' vs
 'interrupts-extended' text
Message-ID: <20141103181428.GH23619@ld-irv-0074>
References: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 05:35:31PM -0600, Bjorn Helgaas wrote:
> a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property
> first") updated the description to say that:
> 
>   - Both 'interrupts' and 'interrupts-extended' may be present
>   - Software should prefer 'interrupts-extended'
>   - Software that doesn't comprehend 'interrupts-extended' may use
>     'interrupts'
> 
> But there is still a paragraph at the end that prohibits having both and
> says 'interrupts' should be preferred.
> 
> Remove the contradictory text.
> 
> Fixes: a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property first")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: stable@vger.kernel.org	# v3.13+

Acked-by: Brian Norris <computersforpeace@gmail.com>

Thanks for noticing.
