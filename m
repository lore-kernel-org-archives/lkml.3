Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab3GaNxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:53:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19485 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756443Ab3GaNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:53:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TTrEUnfWfNkvlEKxJK8T2uUjJ5VSCIX0=
Date: Wed, 31 Jul 2013 09:53:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Greg KH <greg@kroah.com>
Cc: Tony Lindgren <tony@atomide.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130731135346.GN5882@titan.lakedaemon.net>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731123351.GA30474@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:33:51AM -0700, Greg KH wrote:
> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> > Hi all,
> > 
> > Probably the biggest kernel data bloat issue is in the ARM land, but
> > it also seems that it's becoming a Linux generic issue too, so I
> > guess it could be discussed in either context.
> 
> Why is it specific to ARM?  What is so unique to ARM that causes it to
> "bloat"?
> 
> And what exactly do you mean by "bloat"?

Perhaps he's referring to the multiplatform effort?  You'd get a lot of
board code that wouldn't be used at each boot.  This should be declining
though...

thx,

Jason.
