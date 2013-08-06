Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3HFKNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3HFKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:13:04 -0400
Date: Tue, 6 Aug 2013 18:14:21 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Message-ID: <20130806101421.GA29283@kroah.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
 <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com>
 <20130806093356.GA27889@kroah.com>
 <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:37:25PM +0300, Pantelis Antoniou wrote:
> > I don't like this at all, sorry.
> > 
> 
> Don't shoot the messenger please...
> 
> This is all about fixing a crash without messing too many things.

I understand, it's not your fault at all.

> > And I was waiting for the day when people started to finally remove
> > platform devices from the system, I always thought it would never work
> > properly.  Good luck with this, I think you have a lot of work ahead of
> > yourself...
> > 
> 
> I know.
> 
> Platform device removal is the wild-wild west...
> 
> If I had to make a wish, would be to kill platform_device completely and
> integrate all it's functionality in the the vanilla device.

YES!!!!

> What exactly is a platform device anyway?

Originally it was a "something that wasn't connected to a bus, but just
had memory-mapped i/o."  Like the PS2 keyboard controller.

Embedded systems got ahold of this and went to town, and made everything
a platform device because they could, and no one was paying attention.

Then OF came along and used it as well, and you know the rest...

I think we need to get the ACPI and OF people, and me, in a room
together at the kernel summit and not let us out until we have this all
worked out.

thanks,

greg k-h
