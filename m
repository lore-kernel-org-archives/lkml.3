Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaIXIH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:07:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaIXIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:07:19 -0400
Date: Tue, 23 Sep 2014 22:27:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] usb: core: log more general message on malformed
 LANGID descriptor
Message-ID: <20140924052759.GB20986@kroah.com>
References: <alpine.DEB.2.11.1409232013320.2145@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409232013320.2145@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:28:49PM +0000, Scot Doyle wrote:
> I'd like to change this error message:
> [    3.325837] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409
> 
> into an error message followed by a debug message:
> [    3.324726] usb 1-4: malformed string descriptor; unknown language, defaulting to English
> [    3.327514] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409
> 
> in order to communicate more information from the log itself. Are there 
> any problems with this approach? Would it be better to put all the 
> information on a single line? Something else?

How about just one line, why two?

And something like "device not implementing langid specifier, defaulting
to English", but cleaned up to sound a bit better?

thanks,

greg k-h
