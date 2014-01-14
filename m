Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaANXL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:11:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaANXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:11:25 -0500
Date: Tue, 14 Jan 2014 15:12:03 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/62] 3.10.27-stable review
Message-ID: <20140114231203.GE7877@kroah.com>
References: <20140114002710.464561569@linuxfoundation.org>
 <52D4A8BF.2080207@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D4A8BF.2080207@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 07:02:23PM -0800, Guenter Roeck wrote:
> On 01/13/2014 04:26 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.27 release.
> >There are 62 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Jan 16 00:26:56 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> New build failures:
> 	m68k:allmodconfig
> 	sparc64:allmodconfig
> 
> drivers/net/virtio_net.c: In function 'receive_mergeable':
> drivers/net/virtio_net.c:330:29: warning: dereferencing 'void *' pointer [enabled by default]
> drivers/net/virtio_net.c:330:29: error: request for member 'virtual' in something not a structure or union
> 
> Caused by "virtio_net: fix error handling for mergeable buffers".

Hopefully we now have a fix for this one.

thanks for testing and finding this.

greg k-h
