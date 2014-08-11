Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHKSiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:38:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaHKSiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:38:00 -0400
Date: Tue, 12 Aug 2014 02:37:20 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Jose Rivera <German.Rivera@freescale.com>
Subject: Re: location for new bus driver-- drivers/bus? drivers/misc?
Message-ID: <20140811183720.GC32566@kroah.com>
References: <9953b08b77224e738a1a1672dcf209c5@BY2PR0301MB0743.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9953b08b77224e738a1a1672dcf209c5@BY2PR0301MB0743.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 04:25:49PM +0000, Stuart Yoder wrote:
> Greg,
> 
> We (Freescale) have a patch series nearly ready to send out
> for a new bus driver.  It's for a block we call the Freescale
> 'Management Complex' which manages discoverable hardware objects.
> The Linux bus driver enumerates these objects, binds discovered
> objects to drivers just like PCI or any normal bus driver.

Sounds good.

> Question is-- where should this go in the kernel and who would
> the maintainer be to cc: the RFC?  I don't think it warrants
> a top level driver directory beside pci, usb, etc.  Most likely
> place is drivers/bus or drivers/misc (?).
> 
> We currently have it in drivers/bus, but as far as I can see
> there is no maintainer per se for that directory.  You and 
> Arnd manage misc so thought I would ask.

I don't remember why drivers/bus/ came about, Arnd, you created it,
should we be putting random bus controllers in this directory?

And if so, sure, I can maintain drivers/bus/ along with the misc/char
drivers, it's not a big deal.

thanks,

greg k-h
