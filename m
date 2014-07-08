Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaGHIKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:10:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30029 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753416AbaGHIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:10:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182F+8tzcUdBd8TLlm7BjvD
Date: Tue, 8 Jul 2014 01:10:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: balbi@ti.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mach-omap1: Fix call to omap_cfg_reg
Message-ID: <20140708081048.GA28884@atomide.com>
References: <1404493320-5606-1-git-send-email-xerofoify@gmail.com>
 <20140707081456.GH28884@atomide.com>
 <CAPDOMVjpqWL-BVUPKig+2d7921105A03c1BX6164RkC=vuXBGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjpqWL-BVUPKig+2d7921105A03c1BX6164RkC=vuXBGQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Krause <xerofoify@gmail.com> [140707 10:42]:
> Hey Tony,
> This seems to be a false positive then.Please reply if it is so I can remove the
> Fix me message.

Yes, just replace the FIXME with a comment please.

Regards,

Tony
