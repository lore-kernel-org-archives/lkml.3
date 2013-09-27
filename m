Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3I0XOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 19:14:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab3I0XOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 19:14:46 -0400
Date: Fri, 27 Sep 2013 16:14:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "Jeff P. Zacher" <ad_sicks@yahoo.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [stable] Re: Dependency bug in the uvcvideo Kconfig
Message-ID: <20130927231445.GC7708@kroah.com>
References: <1828294.VXnhqsmrEo@localhost>
 <CA+MoWDp0zFXaEhYbwsEV_uMg3H0Nabx9iu25ixyuJvgWGxi=Gg@mail.gmail.com>
 <523A2EB4.6070407@infradead.org>
 <1697645.iYIvpGsUS4@localhost>
 <523B5BD6.4000500@infradead.org>
 <523B8225.9040504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523B8225.9040504@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 04:00:53PM -0700, Randy Dunlap wrote:
> On 09/19/13 13:17, Randy Dunlap wrote:
> > On 09/18/13 20:44, Jeff P. Zacher wrote:
> >>  
> >>
> >> You are correct that this problem shown in the forum was in 3.5.4. However, I am 
> >> having wither the same or similar problem in 3.10.7.
> >> Here is the broken config file, saved as .config-bad
> >>
> > 
> > The failing kernel config file is attached.
> 
> For Linux 3.10.x:
> 
> 
> This is already fixed in mainline but patches need to be backported.
> Specifically these 2 commits (in this order):
> 
> 
> commit a0f9354b1a319cb29c331bfd2e5a15d7f9b87fa4
> Author: Randy Dunlap <rdunlap@infradead.org>
> Date:   Wed May 8 17:28:13 2013 -0300
> 
>     [media] media/usb: fix kconfig dependencies
> 
> and
> 
> commit 5077ac3b8108007f4a2b4589f2d373cf55453206
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Wed May 22 11:25:52 2013 -0300
> 
>     Properly handle tristate dependencies on USB/PCI menus
> 

Applied, thanks.

greg k-h
