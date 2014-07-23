Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbaGWHo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:44:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14864 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757438AbaGWHox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:44:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19hQGIpqYBOPCx2jLOMf24e
Date: Wed, 23 Jul 2014 00:43:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: omap-wakeupgen.c: Remove function for fix me
Message-ID: <20140723074328.GI18374@atomide.com>
References: <CAPDOMVinWFVKY=mMOA1f6pd4orOgcKh1kE01MPVaLZi0Z_tMmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVinWFVKY=mMOA1f6pd4orOgcKh1kE01MPVaLZi0Z_tMmg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Krause <xerofoify@gmail.com> [140722 14:12]:
> static void __init irq_pm_init(void)
> 382 {
> 383         /* FIXME: Remove this when MPU OSWR support is added */
> 384         if (!soc_is_omap54xx())
> 385                 cpu_pm_register_notifier(&irq_notifier_block);
> 386 }
> I am wondering is this omap supported now if it is can I remove it?

Does REVISIT cause issues for you with cscope? It may be easier to
replace the cscope bugging FIXME statements with just REVISIT unless
a real fix is provided.

Regards,

Tony
