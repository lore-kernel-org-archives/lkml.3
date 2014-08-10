Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaHJMTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:19:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaHJMTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:19:31 -0400
Date: Sun, 10 Aug 2014 05:18:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
Message-ID: <20140810121856.GD28863@kroah.com>
References: <20140808213457.511493898@linuxfoundation.org>
 <53E63375.2060400@samsung.com>
 <20140809154916.GC22689@kroah.com>
 <87ha1kr2ea.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha1kr2ea.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 08:48:45PM +0900, Satoru Takeuchi wrote:
> At Sat, 9 Aug 2014 08:49:16 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > On Sat, Aug 09, 2014 at 08:43:01AM -0600, Shuah Khan wrote:
> > > On 08/08/2014 03:35 PM, Greg Kroah-Hartman wrote:
> > > >This is the start of the stable review cycle for the 3.16.1 release.
> > > >There are 17 patches in this series, all will be posted as a response
> > > >to this one.  If anyone has any issues with these being applied, please
> > > >let me know.
> > > >
> > > >Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
> > > >Anything received after that time might be too late.
> > > >
> > > >The whole patch series can be found in one patch at:
> > > >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.1-rc1.gz
> > > >and the diffstat can be found below.
> > > >
> > > >thanks,
> > > >
> > > >greg k-h
> > > >
> > > 
> > > Compiled and booted on my test system. No dmesg regressions.
> > 
> > Thanks for testing all of these and letting me know.
> > 
> > greg k-h
> 
> All 3.16.1-rc1, 3.15.10-rc1, 3.14.17-rc1, 3.10.53-rc1, and 3.4.103-rc1 passed
> my test.
> 
> # Five stable-rc kernels! It's the largest number I've ever tested at a one time :-)

I think it's the largest number I've ever sent out at one time either,
not something I want to do very often :(

Thanks for testing all of these and letting me know.

greg k-h
