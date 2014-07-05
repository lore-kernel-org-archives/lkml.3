Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaGERmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 13:42:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaGERmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:42:42 -0400
Date: Sat, 5 Jul 2014 10:47:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/19] 3.4.97-stable review
Message-ID: <20140705174701.GB17206@kroah.com>
References: <20140704221436.423715636@linuxfoundation.org>
 <53B78F75.6080206@roeck-us.net>
 <871tu0guui.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tu0guui.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 03:53:09PM +0900, Satoru Takeuchi wrote:
> At Fri, 04 Jul 2014 22:39:01 -0700,
> Guenter Roeck wrote:
> > 
> > On 07/04/2014 03:15 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.4.97 release.
> > > There are 19 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun Jul  6 22:14:29 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 137 pass: 111 skipped: 20 fail: 6
> > Failed builds:
> > 	alpha:allmodconfig
> > 	arm:spear6xx_defconfig
> > 	score:defconfig
> > 	sparc64:allmodconfig
> > 	unicore32:defconfig
> > 	xtensa:allmodconfi
> > 
> > Qemu tests all passed.
> > 
> > Results are as expected.
> > 
> > Details are available at http://server.roeck-us.net:8010/builders.
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

Great, thanks for testing and letting me know.

greg k-h
