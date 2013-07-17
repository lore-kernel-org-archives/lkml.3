Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab3GQE0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:26:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3GQE0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:26:00 -0400
Date: Tue, 16 Jul 2013 21:13:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] PHY Framework for 3.12 merge window
Message-ID: <20130717041327.GA20201@kroah.com>
References: <51E53EC2.5080401@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E53EC2.5080401@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 06:08:26PM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> Here's the pull request for the PHY Framework which I've been working on for a
> while.
> 
> I've applied these patches on the current linux mainline HEAD (which has one
> commit after 3.11-rc1 is tagged).
> 
> Even before this framework is merged, quite a few people started using it. I've
> queued those patches along with the PHY framework as well.
> 
> I'm also planning to maintain this framework henceforth and will be sending
> pull requests for anything related to this framework or users of this framework.
> 
> Let me know if you want any changes on this pull request
> 
> Thanks
> Kishon
> 
> The following changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf:
> 
>   Merge tag 'ext4_for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-14 21:47:51
> -0700)
> 
> are available in the git repository at:
> 
> 
>   git://gitorious.org/linuxphy/linuxphy.git tags/phy-for-v3.12

I'm sorry, but I can't pull from a non-kernel.org account.  And, why is
this a pull request at all?   There aren't many patches in this series,
I can take them just fine through email.  I only do pull requests from a
_very_ limited number of people whom I have been working with for a long
time, everyone else I handle just fine with email.

Also, why me for this?   Should it go through my "char/misc" tree?  Do
you have sign-offs for the subsystems that you touch?  Will you be
moving more phy code from the different subsystems (like all the USB phy
code), into here as well?  Or is this just for new devices?

thanks,

greg k-h
