Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3EJP2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:28:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3EJP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:28:01 -0400
Date: Fri, 10 May 2013 08:28:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/73] 3.9.2-stable review
Message-ID: <20130510152800.GA11798@kroah.com>
References: <20130509222526.480204972@linuxfoundation.org>
 <1368199414.4694.3.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368199414.4694.3.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 03:23:34PM +0000, Shuah Khan wrote:
> On Thu, 2013-05-09 at 15:24 -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.9.2 release.
> > There are 73 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat May 11 22:23:28 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.2-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Patches applied cleanly to 3.0.77, 3.4.44, 3.8.12, and 3.9.1 
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>     (3.4.45-rc1, 3.8.13-rc1, and 3.9.2-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>     (3.0.78-rc1, 3.4.45-rc1, 3.8.13-rc1, and 3.9.2-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the previous
> dmesgs for each of these releases.

Wonderful, thanks for testing all of these and letting us know.

greg k-h
