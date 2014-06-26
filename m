Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaFZTJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:09:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFZTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:09:43 -0400
Date: Thu, 26 Jun 2014 15:09:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: shuah.kh@samsung.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
Message-ID: <20140626190926.GB5565@kroah.com>
References: <20140624154952.751713761@linuxfoundation.org>
 <53A9D69E.2050008@samsung.com>
 <8761jpics9.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761jpics9.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:00:54PM +0900, Satoru Takeuchi wrote:
> At Tue, 24 Jun 2014 13:50:54 -0600,
> Shuah Khan wrote:
> > 
> > On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.15.2 release.
> > > There are 61 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu Jun 26 15:49:36 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.2-rc1.gz
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Compiled and booted on my test system. No dmesg regressions.
> 
> All 3.15.2-rc1, 3.14.9-rc1, 3.10.45-rc1, and 3.4.95-rc1 passed my test.
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

Thanks for testing all of these and letting me know.

greg k-h
