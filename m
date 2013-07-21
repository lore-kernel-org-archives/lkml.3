Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3GUBef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 21:34:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3GUBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 21:34:34 -0400
Date: Sat, 20 Jul 2013 18:34:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/38] 3.9.11-stable review
Message-ID: <20130721013445.GB20212@kroah.com>
References: <20130719052047.858393825@linuxfoundation.org>
 <8761w4agt7.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761w4agt7.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 09:37:56AM +0900, Satoru Takeuchi wrote:
> At Thu, 18 Jul 2013 22:21:16 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > ---------------
> > Note, this is the LAST 3.9-stable kernel release that I will be doing.
> > Please move to the 3.10-stable branch as soon as possible.
> > ---------------
> > 
> > This is the start of the stable review cycle for the 3.9.11 release.
> > There are 38 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Jul 21 05:20:01 UTC 2013.
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

Thanks for testing this, and the other kernels, out and letting me know.

greg k-h
