Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaHOTDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:03:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:9786 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbaHOTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:03:17 -0400
Date: Fri, 15 Aug 2014 15:03:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: Random MAC address on my BeagleBone White
Message-ID: <20140815150314.60d01877@gandalf.local.home>
In-Reply-To: <20140815184911.GJ17027@pengutronix.de>
References: <20140815134221.08c546a0@gandalf.local.home>
	<20140815184911.GJ17027@pengutronix.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 20:49:11 +0200
Markus Pargmann <mpa@pengutronix.de> wrote:

> Hi Steven,
> 
 
> The am335x SoC already has 4 registers which contain two unique vendor
> MAC addresses, so they should be used automatically instead of a random
> one.
> 
> As you mentioned above, I sent a series to read and use those addresses
> in the linux kernel. There were some problems with the series which I
> fixed to send a new version of the series, but I didn't send it yet. I
> will try to resend it tomorrow and Cc you. It would be great if you
> could test it.
> 

Yep, but I don't work on weekends (Chief Home Officer's orders). Well,
I should say, I don't do computer work on weekends. House work on the
other hand, plenty (Again, the CHO's orders). It will have to wait till
Monday.

> As far as I know, barebox also works with the beaglebone white and it
> should set the correct MAC address as well. So if you need the same IP
> address in linux as in the bootloader, you could try barebox.

Maybe I'll give it a try. But if your stuff works I'll be fine with
that.

Thanks! Hopefully I'll be using this board in my ktest tutorial at
ELCEU in October.

-- Steve
