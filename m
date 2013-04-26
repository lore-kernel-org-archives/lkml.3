Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3DZUdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:33:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63085 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3DZUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:33:48 -0400
Date: Fri, 26 Apr 2013 13:33:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch for-3.8-rc8] usb, chipidea: fix link error when
 USB_EHCI_HCD is a module
Message-ID: <20130426203345.GA25959@kroah.com>
References: <alpine.DEB.2.02.1304261323060.17754@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261323060.17754@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you mean "3.9" in your subject: right?

On Fri, Apr 26, 2013 at 01:25:01PM -0700, David Rientjes wrote:
> Fixes link error when USB_EHCI_HCD=m and USB_CHIPIDEA_HOST=y:
> 
> 	drivers/built-in.o: In function `ci_hdrc_host_init':
> 	drivers/usb/chipidea/host.c:104: undefined reference to `ehci_init_driver'
> 
> as a result of commit 09f6ffde2ece ("USB: EHCI: fix build error by making
> ChipIdea host a normal EHCI driver").
> 
> Cc: stable@vger.kernel.org [v3.7+]
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/usb/chipidea/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

There have been a ton of chipidea changes recently in linux-next.  This
really just looks like you got the configuration wrong, nothing that is
needed at this point in the release cycle, right?

thanks,

greg k-h
