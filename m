Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKKFbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:31:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaKKFbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:31:39 -0500
Date: Tue, 11 Nov 2014 14:30:20 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH RESEND 1/4] core: platform: add warning if driver has no
 owner
Message-ID: <20141111053020.GB29706@kroah.com>
References: <1414514443-28943-1-git-send-email-wsa@the-dreams.de>
 <1414514443-28943-2-git-send-email-wsa@the-dreams.de>
 <CA+8MBbKZ4_OdrW=MurQ+OO8YW6x1iAF+thB5XASE4wXmXnREtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKZ4_OdrW=MurQ+OO8YW6x1iAF+thB5XASE4wXmXnREtQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 01:32:08PM -0800, Tony Luck wrote:
> > +       if (!drv->owner)
> > +               printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);
> 
> This showed up in next-20141110 and on ia64 I see 44 "needs an owner" messages,
> even from drivers like e1000.
> 
> Anyone else seeing anything like that? Or is some ia64 initialization path
> missing an update?

Yes, sorry, this patch is now reverted.

greg k-h
