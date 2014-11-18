Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaKRQYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:24:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47507 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbaKRQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:24:38 -0500
X-Sasl-enc: efTHt2Zb+5OERzUfcmU9BsyUgj9ti3XDaJ2AHQ0aHEHm 1416327877
Date: Tue, 18 Nov 2014 08:24:36 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 driver-core tree
Message-ID: <20141118162436.GA1108@kroah.com>
References: <20141118181222.451b84d1@canb.auug.org.au>
 <20141118152531.GD8223@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118152531.GD8223@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 09:25:31AM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Nov 18, 2014 at 06:12:22PM +1100, Stephen Rothwell wrote:
> > Hi Felipe,
> > 
> > Today's linux-next merge of the usb-gadget tree got a conflict in
> > drivers/usb/dwc2/gadget.c between commit 7c3e90537b74 ("usb: dwc2: drop
> > owner assignment from platform_drivers") from the driver-core tree and
> 
> why is that commit in the driver-core tree ? It wasn't even acked by
> Paul Z. It wasn't sent to linux-usb either.
> 
> Sure, it's minimal, but I'd expect a little cordiality in Ccing driver
> maintainers ;-)

We fixed up many hundreds of drivers all at once, it was easier to take
that change through my driver-core tree than try to coordinate in
everyone's different trees and end up missing some usages.

thanks,

greg k-h
