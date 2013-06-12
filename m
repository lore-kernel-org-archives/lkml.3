Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3FLRFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:05:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49379 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:05:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JH6U/6e6cn8Lvl7R4VLnf
Date: Wed, 12 Jun 2013 10:04:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: linux@arm.linux.org.uk, balbi@ti.com, shc_work@mail.ru,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: omap-usb-host: Fix memory leaks
Message-ID: <20130612170457.GJ8164@atomide.com>
References: <1369400818-31625-1-git-send-email-rogerq@ti.com>
 <20130530210025.GE6467@atomide.com>
 <51A84E7A.106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A84E7A.106@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130531 00:23]:
> Hi Tony,
> 
> On 05/31/2013 12:00 AM, Tony Lindgren wrote:
> > Hi Roger,
> > 
> > * Roger Quadros <rogerq@ti.com> [130524 06:12]:
> >> Fix memory leaks in the error path.
> >> Also, use platform_device_register_full() to allocate
> >> the platform devices and set platform data.
> > 
> > If you need this for the v3.10-rc, you should describe why this patch
> > is needed and ideally have some oops or regression causing commit
> > listed. Care to update the description for that?
> 
> There is no oops or regression happening. Just that there will be a
> small memory leak if any of the memory allocations fail or if the
> platform device is destroyed.
> 
> If it doesn't look that serious to you then it can wait.
> But if we move to device tree only boot then this patch and the file
> "usb-host.c" might not be required at all.

OK, applying into omap-for-v3.11/fixes-non-critical as we cannot
remove it yet.

Regards,

Tony
