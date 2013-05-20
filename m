Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3ETSjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:39:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3ETSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:39:07 -0400
Date: Mon, 20 May 2013 11:39:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hjk@hansjkoch.de
Subject: Re: [PATCH v4 1/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20130520183906.GA14851@kroah.com>
References: <1368802420-26723-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368802420-26723-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 05:53:39PM +0300, Eli Billauer wrote:
> This is the documentation for the Xillybus driver. It's intended for kernel
> maintainers, since actual users will most likely rely on other documentation.
> 
> It has turned out somewhat tricky to put Xillybus in one of the existing
> categories of device drivers. I placed it under drivers/uio, mainly because it
> shares the spirit of a generic driver allowing userspace programs to talk
> directly with hardware. Unlike the classic UIO devices, Xillybus' char files
> shouldn't be memory mapped, but rather used in the regular manner as streams
> of data.

Because of that, this isn't a UIO driver at all.  It doesn't use the UIO
interfaces, so it shouldn't be in this directory, sorry.

thanks

greg k-h
