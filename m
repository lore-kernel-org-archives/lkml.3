Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3AQRbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:31:38 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18289 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611Ab3AQRbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:31:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Qd5PbwPiolS+X27KqiVk9
Date: Thu, 17 Jan 2013 09:31:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, balbi@ti.com, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
Message-ID: <20130117173131.GL14149@atomide.com>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
 <50F7C4A7.5060202@ti.com>
 <20130117093417.GH10814@arwen.pp.htv.fi>
 <50F7CA82.4050509@ti.com>
 <20130117100510.GI10814@arwen.pp.htv.fi>
 <20130117100919.GJ10814@arwen.pp.htv.fi>
 <1358418917.6252.31.camel@cumari.coelho.fi>
 <50F7D535.6030205@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F7D535.6030205@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [130117 02:44]:
> On 01/17/2013 11:35 AM, Luciano Coelho wrote:
> > This out-of-tree code doesn't explain why we need to do the
> > enable/disable in the board file.  We just need to do things a bit
> > differently in the driver.  I'll start cleaning all this stuff up for
> > -next pretty soon.
> > 
> > For now, ie. 3.7 (stable) and 3.8, do we agree in taking this patch so
> > that TI-ST at least works on Panda? Simply reverting the gpio removal
> > patch doesn't help, because we also need to handle the UART2 muxing
> > (which my patch does as well).
> 
> I don't see better way to fix this either. In any case, I give you my:
> 
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

So what is actually broken? The horrible bluetooth muxing over serial
port? If so, let's rather fix it properly than even attempt to fix
it as it seems that it's been broken for two merge windows now.

Also, let's just do absolutely minimal board-*.c file fixes now.
This thing should be just moved to use DT so we can flip over omap4
to be DT only and drop estimated 5k LOC from mach-omap2.

Regards,

Tony 
