Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3AZAWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:22:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44186 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3AZAWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:22:10 -0500
Date: Fri, 25 Jan 2013 16:22:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: pv-drivers@vmware.com, Neil Horman <nhorman@tuxdriver.com>,
        acking@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [Pv-drivers] [PATCH 1/1] VSOCK: Introduce VM Sockets
Message-ID: <20130126002208.GB5132@kroah.com>
References: <1359135470-30677-1-git-send-email-acking@vmware.com>
 <1359135470-30677-2-git-send-email-acking@vmware.com>
 <20130125235953.GA4833@hmsreliant.think-freely.org>
 <2312112.Fz0qTjDOJB@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2312112.Fz0qTjDOJB@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 04:15:19PM -0800, Dmitry Torokhov wrote:
> Hi Neil,
> 
> On Friday, January 25, 2013 06:59:53 PM Neil Horman wrote:
> > On Fri, Jan 25, 2013 at 09:37:50AM -0800, acking@vmware.com wrote:
> > > +
> > > +config VMWARE_VSOCK
> > > +	tristate "Virtual Socket protocol"
> > > +	depends on VMWARE_VMCI
> > 
> > What is CONFIG_VMWARE_VMCI?  I don't find that in any Kconfig in the tree?
> > 
> > I''m still looking over the rest, but I get build issues if I just remove
> > the dependency.
> 
> VMCI is in linux-next at the moment.

>From the char-misc-next git tree to be specific.

thanks,

greg k-h
