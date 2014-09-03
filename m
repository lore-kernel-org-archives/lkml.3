Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbaICWEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:04:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27917 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756285AbaICWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:04:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NFGY+7k5gGIUbHzFT6XWo
Date: Wed, 3 Sep 2014 15:04:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: kpark3469@gmail.com, keun-o.park@windriver.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        afzal.mohd.ma@gmail.com
Subject: Re: [PATCHv2] ARM: debug: uncompress debug support for omap2plus
Message-ID: <20140903220433.GQ11766@atomide.com>
References: <1409038140-7433-1-git-send-email-kpark3469@gmail.com>
 <20140826075831.GU30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826075831.GU30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [140826 00:58]:
> On Tue, Aug 26, 2014 at 04:28:59PM +0900, kpark3469@gmail.com wrote:
> > From: Sahara <keun-o.park@windriver.com>
> > 
> > Since OMAP low-level debug code places data in the .data section,
> > The symbol DEBUG_UNCOMPRESS was defined with !DEBUG_OMAP2PLUS_UART.
> > This patch removes the part using data section in debug/omap2plus.S,
> > so DEBUG_UNCOMPRESS is now available on OMAP system.
> > 
> > Signed-off-by: Sahara <keun-o.park@windriver.com>
> > Tested-by: Afzal Mohammed <afzal.mohd.ma@gmail.com> (on am335x beagle
> > bone white)
> 
> You need to consider whom you are sending this to.  It would be well
> worth including the OMAP maintainer, Tony Lindgren.

Thanks saw it and replied yesterday that we should just rip out
the SoC detection and use standard 8250 debug_ll code.

Regards,

Tony
