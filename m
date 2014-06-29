Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaF2BhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 21:37:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaF2BhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 21:37:14 -0400
Date: Sat, 28 Jun 2014 18:37:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 000/139] 3.15.3-stable review
Message-ID: <20140629013701.GB11062@kroah.com>
References: <20140628174605.352098823@linuxfoundation.org>
 <53AF4295.3010408@roeck-us.net>
 <87d2dsv8n3.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2dsv8n3.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 09:53:20AM +0900, Satoru Takeuchi wrote:
> At Sat, 28 Jun 2014 15:32:53 -0700,
> Guenter Roeck wrote:
> > 
> > On 06/28/2014 10:46 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.15.3 release.
> > > There are 139 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Mon Jun 30 17:45:39 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 144 pass: 136 skipped: 5 fail: 3
> > Failed builds:
> > 	powerpc:allmodconfig
> > 	powerpc:allmodconfig
> > 	unicore32:defconfig
> > 
> > Qemu tests all passed.
> > 
> > Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.
> > 
> > Guenter
> > 
> 
> 3.15.3-rc1, 3.14.10-rc1, 3.10.46-r1, and 3.4.96-rc1 passed my test.
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
