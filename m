Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab3DBCmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:42:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50712 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3DBCmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:42:07 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Apr 2013 19:42:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@denx.de>
Cc: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dzu@denx.de
Subject: Re: UIO device tree bindings.
Message-ID: <20130402024212.GA19431@roeck-us.net>
References: <20130401142336.GA18034@amd.pavel.ucw.cz>
 <20130401154008.GA20963@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401154008.GA20963@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 05:40:08PM +0200, Pavel Machek wrote:
> On Mon 2013-04-01 16:23:36, Pavel Machek wrote:
> > Hi!
> > 
> > I'd like to get uio device tree bindings to work -- with recent FPGA
> > parts it will be important. Latest version I see is 
> > 
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073087.html
> > 
> > ... Is there anything newer?
> > 
> > I red the discussion, and main problem seems to be the "tell kernel to
> > drive this device tree device", right?
> 
Problem seems to be the notion that the proposed devicetree entry would not
describe the hardware, but its use. Not really sure I understand the problem,
as I would see the hardware description to be "A hardware device which is
compatible to and managed by the generic-uio driver". I would argue that
this _is_ a hardware description (if not, what is ?), but I am not the one
to make the call.

> So... here's the port to recent kernels. Not for mainline.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> 
Turns out this is exactly what I need, and your post saves me the time
I would have spent writing essentially the same code and submitting it,
only to have it rejected.

Thanks a lot for digging this up!

Guenter
