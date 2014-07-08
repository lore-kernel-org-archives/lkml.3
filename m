Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaGHWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:11:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:11:52 -0400
Date: Tue, 8 Jul 2014 15:16:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 000/122] 3.15.5-stable review
Message-ID: <20140708221616.GF29964@kroah.com>
References: <20140707235734.234226883@linuxfoundation.org>
 <53BBF17D.9040001@roeck-us.net>
 <87wqbn6bh7.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqbn6bh7.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:50:44AM +0900, Satoru Takeuchi wrote:
> At Tue, 08 Jul 2014 06:26:21 -0700,
> Guenter Roeck wrote:
> > 
> > On 07/07/2014 04:56 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.15.5 release.
> > > There are 122 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed Jul  9 23:57:10 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > 
> > Build results:
> > 	total: 139 pass: 136 fail: 3
> > Failed builds:
> > 	powerpc:allmodconfig (binutils 2.23)
> > 	powerpc:allmodconfig (binutils 2.24)
> > 	unicore32:defconfig
> > 
> > Qemu tests all passed.
> > 
> > Results are as expected.
> > 
> > Details are available at http://server.roeck-us.net:8010/builders.
> > 
> > For the unicore32 build to pass in this release, the following
> > additional patches would be needed.
> > 
> > 73fa540618 drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
> > c863810cef drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
> > 
> > A workaround patch to address the powerpc build failures is pending.
> > I'll send you a note after it is available if Ben doesn't Cc: stable.
> 
> 3.15.5-rc1, 3.14.12-rc1, 3.10.48-rc1, and 3.4.98-rc1 passed my test.
> Build errors in 3.14.11 and 3.10.11-rc1 disappeared.
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

Thanks for testing these and letting me know.

greg k-h
