Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3HCCeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 22:34:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3HCCeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 22:34:00 -0400
Date: Sat, 3 Aug 2013 10:35:12 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130803023512.GA22635@kroah.com>
References: <51FC5478.40500@linuxtoys.org>
 <51FC5A97.1090102@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC5A97.1090102@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:19:19PM -0700, Bob Smith wrote:
> This character device can give daemons an interface similar to
> the kernel's /sys and /proc interfaces.   It is a nice way to
> give user space drivers real device nodes in /dev.

Why not just use the cuse interface instead?  How does this differ from
that /dev node interaction?

And how does this have anything to do with /sys?  I can't see any sysfs
interaction in the code, or am I missing it?

thanks,

greg k-h
