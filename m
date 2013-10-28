Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3J1Qfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:35:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3J1Qfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:35:50 -0400
Date: Mon, 28 Oct 2013 09:35:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: return correct error code on unimplemented mmap()
Message-ID: <20131028163549.GC4797@kroah.com>
References: <1382977710-1966-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382977710-1966-1-git-send-email-vladimir_zapolskiy@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 06:28:30PM +0200, Vladimir Zapolskiy wrote:
> Both POSIX.1-2008 and Linux Programmer's Manual have a dedicated return
> error code for a case, when a file doesn't support mmap(), it's ENODEV.
> 
> This change replaces overloaded EINVAL with ENODEV in a situation
> described above for sysfs binary files.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Is this a problem in linux-next or 3.12-rc7 and older kernels?  What
userspace tool is breaking here?

thanks,

greg k-h
