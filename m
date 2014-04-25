Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaDYQhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:37:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaDYQhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:37:12 -0400
Date: Fri, 25 Apr 2014 09:35:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] xhci: fixes for 3.15-rc usb-linus
Message-ID: <20140425163505.GA8382@kroah.com>
References: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:20:12PM +0300, Mathias Nyman wrote:
> Hi Greg                                                                                                
>                                                                                                        
> Second try at this xhci fixes series for 3.15-rc usb-linus.                                                         
> Most of them are very small fixes that didn't make                                                     
> it to 3.14, sitting and waiting for 3.15-rc1 to come out.                                              
>                                                                                                        
> Only the "Prefer endpoint context.." patch  by Julius has a bit more content.                          
>                                                                                                        
> These patches are picked together with Sarah, they are tested on top of                                
> 3.15-rc1, and apply on your current usb-linus branch                                                   

Much better, all now applied.

What's with all that trailing whitespace in your email text?

greg k-h
