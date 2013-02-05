Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab3BEX4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:56:33 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57375 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053Ab3BEX4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:56:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19x8V+6s8WDIMv4+/loSSWH
Date: Tue, 5 Feb 2013 15:56:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: OMAP2+: SoC name and revision unification
Message-ID: <20130205235626.GS25185@atomide.com>
References: <1359660284-5225-1-git-send-email-ruslan.bilovol@ti.com>
 <1359660284-5225-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359660284-5225-2-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ruslan Bilovol <ruslan.bilovol@ti.com> [130131 11:28]:
> This is a long story where for each new generation of
> OMAP we used different approaches for creating
> strings for SoCs names and revisions that this patch
> fixes. It makes future exporting of this information
> to SoC infrastructure easier.

Maybe use name soc_name and soc_rev instead and make
cpu_name and cpu_rev local to the functions?
That would reduce some churn here.

Also this does not apply to my omap-for-v3.9/soc
branch. Care to update this (and possibly the second one)
against that?

Regards,

Tony
