Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab3EWQPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:15:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab3EWQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:15:40 -0400
Date: Thu, 23 May 2013 09:15:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 3.10-rc3
Message-ID: <20130523161539.GB14414@kroah.com>
References: <20130523161457.GA14414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523161457.GA14414@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:14:57AM -0700, Greg KH wrote:
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc2
> 
> for you to fetch changes up to 2a0ebf80aa95cc758d4725f74a7016e992606a39:
> 
>   USB: cxacru: potential underflow in cxacru_cm_get_array() (2013-05-20 11:35:47 -0700)

Linus, you will get a merge conflict with this pull request, in one of
the USB host controller driver.  The fixup should be obvious, but if you
need me to resolve it, I can create another branch for it.

thanks,

greg k-h
