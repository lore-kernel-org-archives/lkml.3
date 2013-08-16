Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3HPCPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:15:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3HPCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:15:32 -0400
Date: Thu, 15 Aug 2013 19:17:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Staging driver fixes for 3.11-rc6
Message-ID: <20130816021707.GG7906@kroah.com>
References: <20130816020710.GA7876@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816020710.GA7876@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:07:10PM -0700, Greg KH wrote:
> The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
> 
>   Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc6
> 
> for you to fetch changes up to ff8a43c10f1440f07a5faca0c1556921259f7f76:
> 
>   USB: keyspan: fix null-deref at disconnect and release (2013-08-14 12:49:27 -0700)
> 
> ----------------------------------------------------------------
> USB fixes for 3.11-rc6

This really was the USB fixes, I don't know where the "Staging" subject
line came from, sorry about that.

I'll resend with the proper subject and mailing lists copied...

greg k-h
