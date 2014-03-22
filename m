Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaCVQYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:24:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaCVQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:24:29 -0400
Date: Sat, 22 Mar 2014 09:25:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/149] 3.13.7-stable review
Message-ID: <20140322162558.GC13385@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
 <532BD009.7020204@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532BD009.7020204@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 10:37:13PM -0700, Guenter Roeck wrote:
> On 03/20/2014 05:02 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.7 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 126 pass: 120 skipped: 4 fail: 2
> 
> qemu tests all passed.
> 
> There are two new build failures.
> 
> Building powerpc:mpc85xx_defconfig ... failed
> Building powerpc:mpc85xx_smp_defconfig ... failed
> 
> The failure is the same in both cases.
> 
> drivers/i2c/busses/i2c-cpm.c: In function 'cpm_i2c_setup':
> drivers/i2c/busses/i2c-cpm.c:450:2: error: implicit declaration of function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-cpm.c:461:2: error: implicit declaration of function 'of_iomap' [-Werror=implicit-function-declaration]

Thanks for testing and letting me know.

greg k-h
