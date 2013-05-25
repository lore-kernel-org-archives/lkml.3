Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3EYMSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:18:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3EYMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:18:30 -0400
Date: Sat, 25 May 2013 05:18:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: stable@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        user-mode-linux-user@lists.sourceforge.net
Subject: Re: UML build broken since 3.0.75 (also affects 3.2.x)
Message-ID: <20130525121851.GB3746@kroah.com>
References: <51A0989A.6070100@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51A0989A.6070100@nagafix.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 05:55:22PM +0700, Antoine Martin wrote:
> Linus' vm patches broke the UML build in 3.0.75 onwards:
> 
>   CC      mm/memory.o
> mm/memory.c: In function ‘vm_iomap_memory’:
> mm/memory.c:2363:2: error: implicit declaration of function
> ‘io_remap_pfn_range’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
> 
> 
> This fix is just a copy of what is found in later kernels.

What is that git commit id?

thanks,

greg k-h
