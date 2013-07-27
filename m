Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab3G0A5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 20:57:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab3G0A5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 20:57:11 -0400
Date: Fri, 26 Jul 2013 17:57:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/79] 3.10.4-stable review
Message-ID: <20130727005710.GA13693@kroah.com>
References: <20130726204721.849052763@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6174D8AC@sisaex01sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6174D8AC@sisaex01sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:19:24AM +0000, Shuah Khan wrote:
> On 07/26/2013 03:21 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.4 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Jul 28 20:45:08 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.4-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.87, 3.4.54 and 3.10.3
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.55-rc1, 3.10.4-rc2)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.88-rc1, 3.4.55-rc1, and 3.10.4-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
> err are clean. No regressions in warn.

Great, thanks for testing and letting me know.

greg k-h
