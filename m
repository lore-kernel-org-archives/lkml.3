Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaHTRUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:20:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaHTRUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:20:36 -0400
Date: Wed, 20 Aug 2014 13:20:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen-pciback: Add MODULE_ALIAS for pciback.
Message-ID: <20140820172029.GA5089@laptop.dumpdata.com>
References: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
 <1408552838-4032-2-git-send-email-konrad.wilk@oracle.com>
 <1408555132.16955.5.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408555132.16955.5.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 06:18:52PM +0100, Ian Campbell wrote:
> On Wed, 2014-08-20 at 12:40 -0400, Konrad Rzeszutek Wilk wrote:
> > The rest of the Xen device drivers use an module alias
> > to load devices when they shop up in XenBus.
> 
> "show".
> >  
> >  MODULE_LICENSE("Dual BSD/GPL");
> >  MODULE_ALIAS("xen-backend:pci");
> > +MODULE_ALIAS("xen:pci");
> 
> Isn't that xen-backend:pci already the right thing for a backend device?
> xen: is for frontends, I thought.

Oh, you are right. Cool! Thanks!
> 
> Ian.
> 
