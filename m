Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3DZWO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:14:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46265 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3DZWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:14:28 -0400
Date: Fri, 26 Apr 2013 15:14:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch for-3.8-rc8] usb, chipidea: fix link error when USB_EHCI_HCD
 is a module
In-Reply-To: <20130426220033.GA27963@kroah.com>
Message-ID: <alpine.DEB.2.02.1304261504120.27014@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1304261323060.17754@chino.kir.corp.google.com> <20130426203345.GA25959@kroah.com> <alpine.DEB.2.02.1304261448350.25408@chino.kir.corp.google.com> <20130426220033.GA27963@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Greg Kroah-Hartman wrote:

> > It's your subsystem, if you want to release a kernel with a known-broken 
> > config, that's your call.
> 
> As you point out, it's been "known broken" since 3.7, no rush now to fix
> it, especially so late in the merge window. :)
> 

It's "known broken" as of today because I've made you aware of it and 
provided a patch to fix it.  I annotated the changelog with 
stable@vger.kernel.org since v3.7 since the problem goes back to that time 
because of the commit quoted in the changelog.

The Kconfig allows for the broken config in 3.8-rc8, so I see no risk 
whatosever in fixing it to prevent specifically that broken combination.  
But again, it's your subsystem so if you'd like to drop this plainly 
obvious fix, that's completely your call.

> The chipidea maintainer has a big update all queued up in my trees for
> 3.10-rc1, if you could verify that linux-next fixes your problem, I
> would appreciate it.
> 

As stated, linux-next as of today has this problem.  If you have a public 
git tree with patches that touch this area that are not pushed to 
linux-next, please send me the location and I'll try the combination 
stated in the changelog.  (You could do that, as well, if you want.)
