Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab3D3XxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:53:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36396 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab3D3XxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:53:15 -0400
Date: Tue, 30 Apr 2013 16:53:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dummy-irq: require the user to specify an IRQ number
Message-ID: <20130430235312.GA1572@kroah.com>
References: <20130429211605.GA4102@redhat.com>
 <alpine.LNX.2.00.1304300651080.20139@pobox.suse.cz>
 <20130430072817.61d3ca9f@lwn.net>
 <alpine.LNX.2.00.1304302240390.20139@pobox.suse.cz>
 <20130430205016.GB26374@kroah.com>
 <alpine.LNX.2.00.1304302311260.20139@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1304302311260.20139@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 11:12:04PM +0200, Jiri Kosina wrote:
> On Tue, 30 Apr 2013, Greg Kroah-Hartman wrote:
> 
> > > From: Jonathan Corbet <corbet@lwn.net>
> > > Subject: [PATCH] dummy-irq: require the user to specify an IRQ number
> > > 
> > > Make sure that we let the user know that without specifying IRQ#, 
> > > dummy-irq driver is useless.
> > > 
> > > Reported-by: Dave Jones <davej@redhat.com>
> > > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > Nice, I'll queue this up after 3.10-rc1 is out, thanks.
> 
> Thanks Greg.
> 
> Do you want me to resend this after rc1, or is it somewhere in your 
> post-rc1 queue already?

It's in my queue already, no need for you to resend this.

thanks,

greg k-h
