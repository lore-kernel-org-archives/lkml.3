Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaKDTnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:43:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaKDTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:43:34 -0500
Date: Tue, 4 Nov 2014 11:42:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P symbol
Message-ID: <20141104194221.GB3722@kroah.com>
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
 <20141103232438.GA11698@kroah.com>
 <54591BDF.8060203@samsung.com>
 <1415128864.20372.189.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415128864.20372.189.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:21:04PM +0100, Paul Bolle wrote:
> On Tue, 2014-11-04 at 19:33 +0100, Sylwester Nawrocki wrote:
> > On 04/11/14 00:24, Greg KH wrote:
> > > This isn't a stable issue...
> > 
> > Sorry for disturbing then, let me go and read the documentation again.
> 
> If I remember correctly, I asked Sylwester to mark this for stable. So
> it's me that should be educated here.
> 
> Why is a patch that allows the users of ARCH_S5PV210 to set
> USB_EHCI_EXYNOS or USB_OHCI_EXYNOS - which they apparently need - for a
> v3.17.y kernel, not a stable issue?

As it's something that no one seemed to ever need before (i.e. it's not
a regression fix), but it would be a "new feature", I don't think it's
really a stable fix.

But feel free to convince me otherwise :)

thanks,

greg k-h
