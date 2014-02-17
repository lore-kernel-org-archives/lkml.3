Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaBQTQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:16:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBQTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:16:09 -0500
Date: Mon, 17 Feb 2014 11:18:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hjk@hansjkoch.de
Subject: Re: UIO and memory from dma_alloc_coherent - UIO_MEM_PHYS?
Message-ID: <20140217191834.GA15282@kroah.com>
References: <53024FAD.2000709@meduna.org>
 <20140217181854.GA7119@kroah.com>
 <530255AA.2080905@meduna.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530255AA.2080905@meduna.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:32:10PM +0100, Stanislav Meduna wrote:
> On 17.02.2014 19:18, Greg KH wrote:
> 
> > The uio_dmem_genirq.c driver showed up in 3.8, so it might be good for
> > you to update your kernel if you want to do DMA memory with a UIO
> > driver, as lots of other things in this area was fixed to accomplish
> > this.
> 
> Ah, OK, I will look into this.
> 
> I am stuck with 3.4 at the moment because of the real-time patches
> and some semantic changes there in the newer kernels necessitating
> much more tweak-and-test time than I currently have...

The real-time patches are available for 3.10, so that shouldn't be an
excuse anymore :)
