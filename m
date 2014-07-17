Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaGQBvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:51:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaGQBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:51:41 -0400
Date: Wed, 16 Jul 2014 18:51:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/84] 3.15.6-stable review
Message-ID: <20140717015100.GD6509@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
 <53C5FF60.5060605@roeck-us.net>
 <87d2d5y3pm.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2d5y3pm.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 07:53:41PM +0900, Satoru Takeuchi wrote:
> At Tue, 15 Jul 2014 21:28:16 -0700,
> Guenter Roeck wrote:
> > 
> > On 07/15/2014 04:16 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.15.6 release.
> > > There are 84 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu Jul 17 23:17:00 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 139 pass: 139 fail: 0
> > 
> > Qemu tests all passed.
> > 
> > Another set of perfect results.
> > 
> > Details are available at http://server.roeck-us.net:8010/builders.
> 
> All 3.15.6-rc1, 3.14.13-rc1, 3.10.49-rc1, and 3.4.99-rc1 passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>    # "selftests" is not added to this list yet.
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
