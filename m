Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3FQXgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:36:48 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35069 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3FQXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:36:46 -0400
Date: Tue, 18 Jun 2013 01:38:08 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Shyti <andi@etezian.org>, arnd@arndb.de, linux-kernel@vger.kernel.org,
        pc@asdf.org, oatilla@gmail.com
Subject: Re: [PATCH 00/19] misc: bh1770glc features and fixes
Message-ID: <20130617233808.GC4454@jack.whiskey>
References: <cover.1371145891.git.andi@etezian.org>
 <20130617225405.GC21613@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617225405.GC21613@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patchset contains a collection of new features and fixes for
> > the bh1770glc driver for the BH1770 and SFH7770 proximity
> > and ambient light sensor device.
> 
> Remind me again why this isn't an drivers/iio/ driver, using that api?

Well, the driver is not written by me, I just found it as it is,
I tried to add new features and fix some bugs.

I can work on it if the supplier sends me a development board,
otherwise I cannot do much :(

> > In few words this is what it brings:
> > - /dev/input/event interface
> > - removal obsolete and wrong parameters
> 
> What do you mean by this?  Userspace parameters?  Did you just change
> the user/kernel api?  Or something else?

mainly user/kernel interfaces and some wrong parameters in the
Kernel. On the second version I'll update also Documentation/ABI.

For example one patch fixes some wrong frequencies that don't
match with the device properties.

Thanks again,
Andi
