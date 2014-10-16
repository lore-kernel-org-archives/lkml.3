Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaJPOwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:52:21 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49316 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaJPOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:52:19 -0400
Date: Thu, 16 Oct 2014 20:22:08 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141016145208.GA8358@sudip-PC>
References: <1413445270-27672-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413445270-27672-2-git-send-email-sudipm.mukherjee@gmail.com>
 <20141016132155.GC3480@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016132155.GC3480@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 08:21:55AM -0500, Felipe Balbi wrote:
> HI,
> 
> On Thu, Oct 16, 2014 at 01:11:10PM +0530, Sudip Mukherjee wrote:
> > sparse was giving the following warning:
> >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > 	        - different lock contexts for basic block
> > 
> > we were returning ENOMEM while still holding the spinlock.
> > The sparse warning was fixed by releasing the spinlock before return.
> > 
> > This patch depends on the previous patch of the series.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> this should be patch one so it can be backported to stable kernels.
> 
my v1 patch fixed only this , while reviewing that one Paul Zimmerman suggested to rewrite the return statements.
so this v2 series had the rewrite and the spinlock error fix.
now if this is to be made the patch one then it will be a duplicate of my v1 followed by another patch for return statements. 
should i do that ?

thanks
sudip

> -- 
> balbi


