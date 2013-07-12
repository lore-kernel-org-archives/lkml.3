Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab3GLR3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:29:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904Ab3GLR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:29:32 -0400
Date: Fri, 12 Jul 2013 10:29:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712172932.GB7627@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61739C88@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61739C88@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 05:20:29PM +0000, Shuah Khan wrote:
> On 07/11/2013 04:24 PM, Greg Kroah-Hartman wrote:
> 
> >
> > This is the start of the stable review cycle for the 3.10.1 release.
> > There are 19 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat Jul 13 21:45:35 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.1-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.85, 3.4.52, 3.9.9, and 3.10
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.53-rc1, 3.9.10-rc1, 3.10.1-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the previous
> dmesgs for each of these releases. dmesg emerg, crit, alert, err are clean.
> No regressions in warn.
> 
> Cross-compile testing:
> HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
>      (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

Great, thanks for testing all of these and letting me know.

greg k-h
