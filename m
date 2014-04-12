Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaDLB4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:56:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaDLB43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:56:29 -0400
Date: Fri, 11 Apr 2014 18:59:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: shuah.kh@samsung.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 000/134] 3.4.87-stable review
Message-ID: <20140412015918.GD6479@kroah.com>
References: <20140410032259.587501440@linuxfoundation.org>
 <5346F76D.8030704@samsung.com>
 <87lhvbxsx7.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhvbxsx7.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 10:01:08AM +0900, Satoru Takeuchi wrote:
> At Thu, 10 Apr 2014 13:56:29 -0600,
> Shuah Khan wrote:
> > 
> > On 04/09/2014 09:21 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.4.87 release.
> > > There are 134 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat Apr 12 03:22:28 UTC 2014.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.87-rc1.gz
> > > and the diffstat can be found below.
> > >
> > 
> > Compiled and booted on my test systems. No dmesg regressions.
> 
> This kernel passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> 
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
> 
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Wonderful, thanks for testing.

greg k-h
