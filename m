Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3F3VIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:08:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:38744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3F3VIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,969,1363158000"; 
   d="scan'208";a="338012042"
Date: Sun, 30 Jun 2013 14:08:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Reilly Grant <grantr@vmware.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xhci: Compute last_ctx from complete set of configured
 endpoints.
Message-ID: <20130630210816.GC4946@xanatos>
References: <1371589753-23277-1-git-send-email-grantr@vmware.com>
 <20130624155758.GB5290@xanatos>
 <215567179.20374384.1372091068135.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <215567179.20374384.1372091068135.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:24:28AM -0700, Reilly Grant wrote:
> On Mon, Jun 24, 2013 at 08:59AM -0700, Sarah Sharp wrote:
> > On Tue, Jun 18, 2013 at 02:09:13PM -0700, Reilly Grant wrote:
> > 
> > So, no, I can't accept this patch.  If this fixes a real problem in
> > some hardware, we'll add a quirk for that hardware.
> 
> Thank you for the clarification. I was not aware of this addendum.
> Could you forward me a link to it? The last revision I can find on the
> Intel web site is from 05/2010.

The xHCI architect hasn't done an official release on the Intel site for
a while now.  I think he's working on a bigger 1.1 release that includes
all the errata over the past couple years.

I think you can get the latest revision by emailing
xhcisupport@intel.com.  If you don't hear back within a week or so,
email me back and I'll send you a PDF.

> This fixed a problem on VMware's virtual hardware. Assuming changing
> behavior will not affect any other systems I will fix it based on this
> information.

Yes, please fix this in VMware's virtual hardware.

Thanks,
Sarah Sharp
