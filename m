Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaDLPT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 11:19:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbaDLPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 11:19:55 -0400
Date: Sat, 12 Apr 2014 08:22:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: shuah.kh@samsung.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/23] 3.14.1-stable review
Message-ID: <20140412152246.GB9024@kroah.com>
References: <20140411161200.236939691@linuxfoundation.org>
 <53487EEF.6070507@samsung.com>
 <87k3avxg24.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3avxg24.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 02:38:59PM +0900, Satoru Takeuchi wrote:
> At Fri, 11 Apr 2014 17:46:55 -0600,
> Shuah Khan wrote:
> > 
> > On 04/11/2014 10:11 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.14.1 release.
> > > There are 23 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.1-rc1.gz
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > 
> > Compiled and booted on my test systems. No dmesg regressions.
> 
> All 3.10.37-rc1, 3.13.10-rc1, and 3.14.1-rc1 passed my test.
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

Thanks for testing and letting me know.

greg k-h
