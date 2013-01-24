Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3AXWJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:09:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:52558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab3AXWJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:09:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,532,1355126400"; 
   d="scan'208";a="252018405"
Date: Thu, 24 Jan 2013 14:08:37 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: XHCI: fix memory leak of URB-private data
Message-ID: <20130124220837.GD5303@xanatos>
References: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org>
 <5101AD55.2000008@fold.natur.cuni.cz>
 <20130124215707.GA30414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124215707.GA30414@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:57:07PM -0800, Greg KH wrote:
> On Thu, Jan 24, 2013 at 10:53:25PM +0100, Martin Mokrejs wrote:
> > Hi Sarah and Alan,
> >   I just saw 3.7.5 patches announced by Greg but I don't see this path in there.
> > And, don't know but maybe this applies to older stable kernels as well?
> > Where will this patch posted originally to linux-usb land?
> > 
> > Ah, is that because the email was actually NOT sent to "stable@"? ;-)
> 
> No.  It's because the patch isn't in Linus's tree yet, which is one of
> the requirements for a patch to be able to get into the stable kernel
> releases.

I'm sending it to Greg today after I test it (and the rest of my queue)
out.  It will be in the stable trees after it hits Linus' tree.

Sarah Sharp
