Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3DYOti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:49:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46670 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab3DYOth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:49:37 -0400
Date: Thu, 25 Apr 2013 07:49:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/42] 3.8.9-stable review
Message-ID: <20130425144934.GA10755@kroah.com>
References: <20130423215205.523980967@linuxfoundation.org>
 <87d2ti99gy.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2ti99gy.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:43:25PM +0900, Satoru Takeuchi wrote:
> At Tue, 23 Apr 2013 14:51:58 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.8.9 release.
> > There are 42 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Apr 25 21:50:11 UTC 2013.
> > Anything received after that time might be too late.
> 
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
> 
>  - Build Machine: debian wheezy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
> 
>  - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB

Thanks for testing these kernels and letting us know.

greg k-h
