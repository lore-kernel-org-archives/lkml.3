Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3FEPj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3FEPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:39:58 -0400
Date: Wed, 5 Jun 2013 08:39:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        sarah.a.sharp@intel.com, linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [RFC PATCH v3 0/4] Add usb2 link powermanagement BESL support
Message-ID: <20130605153957.GA22808@kroah.com>
References: <20130604230534.GB6289@xanatos>
 <Pine.LNX.4.44L0.1306051051130.1078-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1306051051130.1078-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:51:38AM -0400, Alan Stern wrote:
> On Tue, 4 Jun 2013, Sarah Sharp wrote:
> 
> > Alan, Greg, any more comments on this patchset?
> > 
> > It looks fine to me, and we've been testing it internally within Intel,
> > so I'll queue it up for 3.11 if you don't have any more objections.
> 
> No objections to any of the parts touching the USB core.

None from me either.

thanks,

greg k-h
