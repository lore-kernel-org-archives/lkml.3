Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3LMCBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:01:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3LMCBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:01:08 -0500
Date: Thu, 12 Dec 2013 18:02:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131213020258.GC13333@kroah.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212144210.GA1527@ulmo.nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:42:12PM +0100, Thierry Reding wrote:
> On Thu, Dec 12, 2013 at 03:36:29PM +0100, Thierry Reding wrote:
> > This is a simple test module that can be used to allocate, export and
> > delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> > systems that lack a real second driver.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/base/Kconfig        |   4 +
> >  drivers/base/Makefile       |   1 +
> >  drivers/base/dma-buf-test.c | 308 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 313 insertions(+)
> >  create mode 100644 drivers/base/dma-buf-test.c
> 
> And attached is a small test program that I've been using to test this
> new module. It can be built with:
> 
> 	$ gcc -O2 -g -Wall -Werror -I/usr/include/libdrm -o dma-buf-test dma-buf-test.c -ldrm

Please put this in the patch as well (scripts/tests/ ?)

Also fix up the uapi stuff for the ioctls.

thanks,

greg k-h
