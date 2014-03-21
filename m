Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbaCUO6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:58:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaCUO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:58:12 -0400
Date: Fri, 21 Mar 2014 07:59:37 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Matt Sickler <Matt.Sickler@daktronics.com>
Cc: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UIO read(2)/write(2) overrides
Message-ID: <20140321145937.GA30227@kroah.com>
References: <8FAD17D1809CB042A0963E8337B9FE3DD7D823@MB-EXC-04.daktronics.lan>
 <20140321142429.GA25833@kroah.com>
 <8FAD17D1809CB042A0963E8337B9FE3DD7D871@MB-EXC-04.daktronics.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FAD17D1809CB042A0963E8337B9FE3DD7D871@MB-EXC-04.daktronics.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 02:49:28PM +0000, Matt Sickler wrote:
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> >
> >On Fri, Mar 21, 2014 at 02:20:11PM +0000, Matt Sickler wrote:
> >> Tiny patch to let uio-based drivers override the read(2), write(2), and poll(2) syscalls.
> >> The rationale is that some uio-based drivers might want the mmap(2)
> >> functionality of UIO, but have no need for the IRQ semantics of read(2) and write(2).
> >
> >Can you submit a driver that uses these new interfaces as well?  I don't want to add something that isn't used in the kernel.
> 
> We're developing a driver for a new product but the driver is still in
> a state of flux, so it's not ready for posting yet.
> We will definitely get this out there once it's more polished.
> If you want to hold off applying this patch until we have something to
> submit that uses it, I'm fine with that. 

Yes, we will have to wait until we see that driver, thanks.

greg k-h
