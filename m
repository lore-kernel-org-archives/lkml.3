Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaGHWLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:11:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:11:32 -0400
Date: Tue, 8 Jul 2014 15:15:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/94] 3.14.12-stable review
Message-ID: <20140708221556.GE29964@kroah.com>
References: <20140707235756.780319003@linuxfoundation.org>
 <53BBF102.6000507@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBF102.6000507@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:24:18AM -0700, Guenter Roeck wrote:
> On 07/07/2014 04:56 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.14.12 release.
> >There are 94 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Wed Jul  9 23:57:44 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 140 pass: 137 fail: 3
> Failed builds:
> 	powerpc:allmodconfig (binutils 2.23)
> 	powerpc:allmodconfig (binutils 2.24)
> 	unicore32:defconfig
> 
> Qemu tests all passed.
> 
> Results are as expected.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 
> For the unicore32 build to pass in this release, the following
> additional patches would be needed.
> 
> 73fa540618 drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue MIME-Version: 1.0
> c863810cef drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue

Great, I will pick those up for the next stable release.

> A workaround patch to address the powerpc build failures is pending.
> I'll send you a note after it is available if Ben doesn't Cc: stable.

Thanks for that.

greg k-h
