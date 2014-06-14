Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaFNOlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 10:41:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaFNOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 10:41:11 -0400
Date: Sat, 14 Jun 2014 07:41:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/12] 3.15.1-stable review
Message-ID: <20140614144102.GB21303@kroah.com>
References: <20140612232044.886466924@linuxfoundation.org>
 <539B15B2.9080205@roeck-us.net>
 <87lhsz3hqf.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhsz3hqf.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 07:31:20PM +0900, Satoru Takeuchi wrote:
> At Fri, 13 Jun 2014 08:16:02 -0700,
> Guenter Roeck wrote:
> > 
> > On 06/12/2014 04:21 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.15.1 release.
> > > There are 12 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat Jun 14 23:20:28 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 143 pass: 135 skipped: 5 fail: 3
> > Failed builds:
> > 	powerpc:allmodconfig (binutils 2.23)
> > 	powerpc:allmodconfig (binutils 2.24)
> > 	unicore32:defconfig
> > 
> > Qemu tests all passed.
> > 
> > Results are as expected.
> > Details are available at http://server.roeck-us.net:8010/builders.
> 
> 3.15.1-rc1, 3.14.8-rc1, 3.10.44-rc1, and 3.4.94-rc1 passed my test.
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
> 
> Thanks,
> Satoru

Thanks for testing all of these and letting me know.

greg k-h
