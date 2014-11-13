Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaKMTMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:12:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaKMTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:12:00 -0500
Date: Thu, 13 Nov 2014 11:11:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.18-rc5
Message-ID: <20141113191159.GA4115@kroah.com>
References: <1415652779-31904-1-git-send-email-balbi@ti.com>
 <20141113180517.GC12546@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113180517.GC12546@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:05:17PM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Nov 10, 2014 at 02:52:59PM -0600, Felipe Balbi wrote:
> > Hi Greg,
> > 
> > Here's another minor for v3.18-rc5. Please consider
> > merging to your usb-linus branch.
> > 
> > Tested with AM437x SK and testusb.
> > 
> > cheers
> > 
> > The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:
> > 
> >   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.18-rc5
> > 
> > for you to fetch changes up to 520fe7633692181bb6d1560d655fbdfbb7c05aaa:
> > 
> >   usb: dwc3: ep0: fix for dead code (2014-11-10 14:39:44 -0600)
> > 
> > ----------------------------------------------------------------
> > usb: fixes for v3.18-rc5
> > 
> > Just one fix here on dwc3 which fixes a minor
> > bug caused by a fix that went in this v3.18-rc
> > cycle.
> > 
> > The corner case is minimal as it can only be
> > reproduced with back-to-back Setup transfers
> > (without starting data or status phase) by
> > means of a LeCroy USB Trainer, where we can
> > generate USB packets any way we like.
> > 
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > 
> > ----------------------------------------------------------------
> > Felipe Balbi (1):
> >       usb: dwc3: ep0: fix for dead code
> > 
> >  drivers/usb/dwc3/ep0.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Gentle reminder on this pull request.

I just got back from Korea, sorry for the delay, will get to this
today...
