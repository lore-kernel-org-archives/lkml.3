Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaKLHYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:24:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKLHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:24:01 -0500
Date: Wed, 12 Nov 2014 15:36:00 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/203] 3.14.24-stable review
Message-ID: <20141112063600.GA7367@kroah.com>
References: <20141112011542.686743533@linuxfoundation.org>
 <5462FE3A.7060601@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462FE3A.7060601@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:29:14PM -0800, Guenter Roeck wrote:
> On 11/11/2014 05:14 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.14.24 release.
> >There are 203 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Nov 14 01:15:14 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 137 pass: 134 fail: 3
> Failed builds:
> 	powerpc:allmodconfig (binutils 2.23)
> 	powerpc:allmodconfig (binutils 2.24)
> 	xtensa:allmodconfig
> 
> Qemu tests:
> 	total: 30 pass: 30 fail: 0
> 
> Builds fail due to
> 
> drivers/of/selftest.c: In function 'of_selftest':
> drivers/of/selftest.c:436:2: error: implicit declaration of function 'of_selftest_property_match_string' [-Werror=implicit-function-declaration]
>   of_selftest_property_match_string();
>   ^
> drivers/of/selftest.c: At top level:
> drivers/of/selftest.c:135:20: warning: 'of_selftest_property_string' defined but not used [-Wunused-function]
>  static void __init of_selftest_property_string(void)
>                     ^
> 
> as mentioned earlier.

I've now fixed this one, if you want to pull the latest stable-git tree.

thanks,

greg k-h
