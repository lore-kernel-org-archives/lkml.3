Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3KIQRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:17:17 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51476 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3KIQRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:17:14 -0500
Date: Sat, 9 Nov 2013 08:19:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/26] 3.4.69-stable review
Message-ID: <20131109161940.GA23303@kroah.com>
References: <20131109065050.089866597@linuxfoundation.org>
 <877gch7iwm.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gch7iwm.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 11:24:09PM +0900, Satoru Takeuchi wrote:
> At Fri,  8 Nov 2013 22:51:29 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.4.69 release.
> > There are 26 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
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

Wonderful, thanks for testing and letting me know.

greg k-h
