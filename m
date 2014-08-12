Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaHLJFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:05:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51957 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbaHLJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:05:49 -0400
X-Sasl-enc: VlVic8UJiXfjvtl1H5i/G9ImU1LTgId2tadytutWSVnS 1407834347
Date: Tue, 12 Aug 2014 17:05:07 +0800
From: Greg KH <greg@kroah.com>
To: Steven Noonan <steven@uplinklabs.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Re: Thunderbolt driver hotplug not working correctly
Message-ID: <20140812090507.GA10105@kroah.com>
References: <20140812085944.GA25906@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812085944.GA25906@falcon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:01:38AM -0700, Steven Noonan wrote:
> Hello Andreas,
> 
> I'm trying out the new Thunderbolt driver in Linus' tree and I'm
> noticing device hotplug isn't quite working correctly.
> 
> I've got a Haswell 2013 MacBook Pro Retina and the Apple-vended
> Thunderbolt Ethernet adapter, which uses the tg3 driver.

I don't think that the relevant ACPI changes have landed in Linus's tree
yet to make this all work.

Matthew, have your changes be merged yet?

thanks,

greg k-h
