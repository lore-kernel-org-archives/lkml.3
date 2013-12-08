Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab3LHPWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:22:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab3LHPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:22:16 -0500
Date: Sun, 8 Dec 2013 07:23:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/32] 3.4.73-stable review
Message-ID: <20131208152347.GA26218@kroah.com>
References: <20131206214956.830407026@linuxfoundation.org>
 <8761qzbe6p.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761qzbe6p.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 11:38:38PM +0900, Satoru Takeuchi wrote:
> At Fri,  6 Dec 2013 13:52:10 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.4.73 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Dec  8 21:49:13 UTC 2013.
> > Anything received after that time might be too late.
> 
> All 3.4.73-rc1, 3.10.23-rc1, and 3.12.4-rc1 can be built and
> boot without any problem. Building kernels with these kernels
> also work fine.
> 
>  - [NEW] test tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - [NEW] test results(kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>
> 
>  - Build Machine: debian jessy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
> 
>  - Test machine: debian jessy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB

Wonderful, thanks for testing.

greg k-h
