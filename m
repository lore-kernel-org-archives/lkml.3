Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3EVQXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:23:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab3EVQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:23:37 -0400
Date: Wed, 22 May 2013 09:23:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Cc: davem@davemloft.net, liquidhorse@gmail.com, andy@greyhouse.net,
        fubar@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, nikolay@redhat.com, vfalico@redhat.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
Message-ID: <20130522162336.GA5761@kroah.com>
References: <519CADA9.9060909@smart-weblications.de>
 <20130522135745.GA14640@kroah.com>
 <519CEF4B.5090108@smart-weblications.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CEF4B.5090108@smart-weblications.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 06:16:11PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> Am 22.05.2013 15:57, schrieb Greg KH:
> > On Wed, May 22, 2013 at 01:36:09PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> >> Hi,
> >>
> >> why is this patch still not backported to 3.4?
> >>
> >> I today tried 3.4.46 from kernel.org, but the patch STILL seems _NOT_ included?
> >>
> >> WHY IS THAT?
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> > 
> > </formletter>
> > 
> 
> 
> I don't want to submit a patch - i wanted to know why this patch still is not in
> the kernel (it is afaics at least 6 months old!)

Perhaps because it was not submitted properly as documented above?

thanks,

greg k-h
