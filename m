Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3FQWyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:54:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:54:06 -0400
Date: Mon, 17 Jun 2013 15:54:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, pc@asdf.org,
        oatilla@gmail.com
Subject: Re: [PATCH 00/19] misc: bh1770glc features and fixes
Message-ID: <20130617225405.GC21613@kroah.com>
References: <cover.1371145891.git.andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 08:20:34PM +0200, Andi Shyti wrote:
> Hi,
> 
> This patchset contains a collection of new features and fixes for
> the bh1770glc driver for the BH1770 and SFH7770 proximity
> and ambient light sensor device.

Remind me again why this isn't an drivers/iio/ driver, using that api?

> In few words this is what it brings:
> - /dev/input/event interface
> - removal obsolete and wrong parameters

What do you mean by this?  Userspace parameters?  Did you just change
the user/kernel api?  Or something else?

> - new relevant parameters for glass attenuation and glass
>   factor, lux compensation due to the LED cover or ink

Again, why not iio?

thanks,

greg k-h
