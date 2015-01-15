Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbbAOFF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:05:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbAOFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:05:54 -0500
Date: Wed, 14 Jan 2015 21:05:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: robh@kernel.org, Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5] ARC: Dynamically determine BASE_BAUD from DeviceTree
Message-ID: <20150115050552.GA24813@kroah.com>
References: <CAL_JsqLzzLajoQAT3nYd5zi4=+zchXfVVPnYNriAZZi4tpa6yA@mail.gmail.com>
 <1420889152-29361-1-git-send-email-vgupta@synopsys.com>
 <54B73FC0.4060506@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B73FC0.4060506@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:49:12AM +0530, Vineet Gupta wrote:
> Hi Greg,
> 
> On Saturday 10 January 2015 04:56 PM, Vineet Gupta wrote:
> > 8250 earlycon is broken on multi-platform ARC because the UART clk
> > value (BASE_BAUD) is fixed at build time.
> > 
> > Instead, determine the appropriate UART clk at runtime; parse the
> > devicetree early for platforms requiring alternate UART clk values
> > (currently only the TB10X platform).
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Cc: linux-serial@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> > ---
> >  arch/arc/include/asm/serial.h | 23 +++++------------------
> >  arch/arc/kernel/devtree.c     | 24 ++++++++++++++++++++++++
> 
> This being all in arch code, do you want me to take this in via ARC tree ?

Sure, that's fine with me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
