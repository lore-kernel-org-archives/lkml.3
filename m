Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3KTQ2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:28:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3KTQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:28:11 -0500
Date: Wed, 20 Nov 2013 08:28:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/12] 3.4.70-stable review
Message-ID: <20131120162838.GC5831@kroah.com>
References: <20131118184130.257996039@linuxfoundation.org>
 <87vbznnxki.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbznnxki.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:04:45PM +0900, Satoru Takeuchi wrote:
> At Mon, 18 Nov 2013 10:41:33 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.4.70 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed Nov 20 18:41:11 UTC 2013.
> > Anything received after that time might be too late.
> 
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
> 
>  - Build Machine: debian jessy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
> 
>  - Test machine: debian jessy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB

Thanks for testing this one, and the 3 others and letting me know they
all work.

greg k-h
