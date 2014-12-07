Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaLGUJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:09:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59465 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbaLGUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:08:59 -0500
X-Sasl-enc: kOnO2DAC5z7eyuWa1A1+0YwSI924XgnJFX3VMzy9X+9l 1417982938
Date: Sun, 7 Dec 2014 12:08:57 -0800
From: Greg KH <greg@kroah.com>
To: Jindrich Makovicka <makovick@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.17 000/122] 3.17.5-stable review
Message-ID: <20141207200857.GB2322@kroah.com>
References: <20141205223305.514276242@linuxfoundation.org>
 <m6200o$b13$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m6200o$b13$1@ger.gmane.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 04:42:00PM +0000, Jindrich Makovicka wrote:
> Hi,
> 
> On Fri, 05 Dec 2014 14:42:54 -0800, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 3.17.5 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I had to revert "netfilter: conntrack: fix race in __nf_conntrack_confirm 
> against get_next_corpse" to be able to boot, getting a kernel panic 
> otherwise:
> 
> http://goo.gl/q86SWy
> 
> It happens in various stages, but seems to be pretty consistently 
> reproducible. This is a desktop running shorewall, with some nfqueue-
> based IP filtering added.

Yes, sorry, I messed up and included a patch I shouldn't have.

thanks for letting me know.

greg k-h
