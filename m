Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaGBGzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:55:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44325 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982AbaGBGzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:55:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bekwAAwPkXxHqnoKoxILy
Date: Tue, 1 Jul 2014 23:55:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FIX ME in function ocpi_enable in file arch/arm/mach-omap1/opci.c
Message-ID: <20140702065531.GS28884@atomide.com>
References: <CAPDOMVgP83G4-znp=9kB-pBrfd2MUK+xvw1-_cRMXqi9P8hrww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVgP83G4-znp=9kB-pBrfd2MUK+xvw1-_cRMXqi9P8hrww@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Krause <xerofoify@gmail.com> [140701 15:51]:
> Hey Tony and Russel ,
> There is a FIX ME message in this function of the file stated in my
> subject line.
> I was wondering what locking is needed  here due to not having experience with
> omap subsystem(s).

Looks like the locking for ocpi_enable would be needed if
it was called from multiple drivers. We are just enabling all
access, so no locking neeed for the current usage.

Regards,

Tony
