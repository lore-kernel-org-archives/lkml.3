Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880Ab3ICVcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab3ICVcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:32:19 -0400
Date: Tue, 3 Sep 2013 17:32:05 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        john453@faraday-tech.com
Subject: Re: usb: host: Faraday fotg210-hcd driver
Message-ID: <20130903213205.GA7433@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	john453@faraday-tech.com
References: <20130903185912.A59316601F4@gitolite.kernel.org>
 <20130903211544.GB2247@redhat.com>
 <20130903212355.GA12978@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903212355.GA12978@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 02:23:55PM -0700, Greg KH wrote:

 > >  > +config USB_FOTG210_HCD
 > >  > +	tristate "FOTG210 HCD support"
 > >  > +	depends on USB
 > >  > +	default N
 > >  > +	---help---
 > >  > +	  Faraday FOTG210 is an OTG controller which can be configured as
 > >  > +	  an USB2.0 host. It is designed to meet USB2.0 EHCI specification
 > >  > +	  with minor modification.
 > >  > +
 > >  > +	  To compile this driver as a module, choose M here: the
 > >  > +	  module will be called fotg210-hcd.
 > >  > +
 > > 
 > > Shouldn't this depend on USB_OTG ?
 > > Seems odd to have OTG related options presented to me when I have that unset.
 > 
 > It's a USB Host controller, so it should be built if you have that
 > option set.  The fact that it can do OTG isn't an issue here, from what
 > I can tell.

Ok. It still likely needs a 'depends on $ARCH (arm?) | COMPILE_TEST' though.

	Dave

PS: What happened with this driver ?

This patch landed twice in your tree, once in 1dd3d123239179fad5de5dc00a6e0014a1918fde from Yuan-Hsin Chen <yhchen@faraday-tech.com>
and then in 7d50195f6c5005d6ae7a789d9a7f0a94d104ee96 from Feng-Hsin Chiang <john453@faraday-tech.com>

Given the former address seems to be broken, perhaps all those mentions of it
in the faraday sources need updating ?

----- The following addresses had permanent fatal errors -----
<yhchen@faraday-tech.com>
    (reason: 553 5.1.3 <yhchen@faraday-tech.com>... Check FTC account failure!<2>)

   ----- Transcript of session follows -----
... while talking to mailhost1.faraday-tech.com.:
>>> DATA
<<< 553 5.1.3 <yhchen@faraday-tech.com>... Check FTC account failure!<2>
550 5.1.1 <yhchen@faraday-tech.com>... User unknown
<<< 503 5.0.0 Need RCPT (recipient)

