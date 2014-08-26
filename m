Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaHZWjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:39:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaHZWjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:39:16 -0400
Date: Tue, 26 Aug 2014 15:39:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: dmaengine <dmaengine@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI support
Message-ID: <20140826223916.GA29089@kroah.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1409066845.30155.17.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409066845.30155.17.camel@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 06:27:25PM +0300, Andy Shevchenko wrote:
> On Tue, 2014-08-19 at 20:29 +0300, Andy Shevchenko wrote:
> > The patchset is targeting two things:
> >  - removal of slave_id which is deprecated (suggested by Arnd Bergmann)
> >  - support BayTrail and Braswell SoCs in PCI case
> > 
> > They are tight with each other, thus comes in one series.
> > 
> > The patch set was BAT tested on Braswell and BayTrail machines.
> > 
> > We would like to push this through slave-dma tree, so, Mark, Greg,
> > Hans-Christian, and Haavard, please, Ack them if you have no objections.
> 
> Greg, gently ping you to get your Ack (or comments) on patches 11/12 and
> 12/12.

Oops, sorry about that, you should now have my acks for both of these.

greg k-h
