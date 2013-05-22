Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3EVTGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:06:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3EVTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:06:42 -0400
Date: Wed, 22 May 2013 12:06:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Cc: davem@davemloft.net, liquidhorse@gmail.com, andy@greyhouse.net,
        fubar@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, nikolay@redhat.com, vfalico@redhat.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
Message-ID: <20130522190640.GA20276@kroah.com>
References: <519CADA9.9060909@smart-weblications.de>
 <20130522135745.GA14640@kroah.com>
 <519CEF4B.5090108@smart-weblications.de>
 <20130522162336.GA5761@kroah.com>
 <519D0B79.6010307@smart-weblications.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519D0B79.6010307@smart-weblications.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:16:25PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> Hi,
> 
> 
> Am 22.05.2013 18:23, schrieb Greg KH:
> > On Wed, May 22, 2013 at 06:16:11PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> >> Am 22.05.2013 15:57, schrieb Greg KH:
> >>> On Wed, May 22, 2013 at 01:36:09PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> >>>> Hi,
> >>>>
> >>>> why is this patch still not backported to 3.4?
> >>>>
> >>>> I today tried 3.4.46 from kernel.org, but the patch STILL seems _NOT_ included?
> >>>>
> >>>> WHY IS THAT?
> >>>
> >>> <formletter>
> >>>
> >>> This is not the correct way to submit patches for inclusion in the
> >>> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> >>> for how to do this properly.
> >>>
> >>> </formletter>
> >>>
> >>
> >>
> >> I don't want to submit a patch - i wanted to know why this patch still is not in
> >> the kernel (it is afaics at least 6 months old!)
> > 
> > Perhaps because it was not submitted properly as documented above?
> > 
> 
> Well, i don't know. I have not written that patch, but tested and applied it
> against 3.4.36 where it worked fine.
> 
> But i am unable to apply it to 3.4.46 (there are rejects if i try to apply it,
> obviously because there were changes in the meanwhile) - It would be cool if
> someone could tell if that patch is really needed anymore with 3.4.46.
> 
> I am no C coder and only have little C experience, but i'd like to use this
> patch with current 3.4 stable Kernel or at least make sure that this patch is
> not needed anymore with current stable kernels...

Why do you think that it is needed?  And does it match up to a specific
change that is already in Linus's tree?  That is a requirement here.

thanks,

greg k-h
