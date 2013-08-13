Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab3HMR5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:57:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab3HMR5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:57:48 -0400
Date: Tue, 13 Aug 2013 10:57:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/60] 3.10.7-stable review
Message-ID: <20130813175747.GB7336@kroah.com>
References: <20130813063331.950321483@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61763FC9@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61763FC9@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 05:18:07PM +0000, Shuah Khan wrote:
> On 08/13/2013 08:02 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.7 release.
> > There are 60 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Aug 15 06:33:14 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.7-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.90, 3.4.57 and 3.10.6
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.58-rc1, 3.10.7-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.91-rc1, 3.4.58-rc1, and 3.10.7-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
> err are clean. No regressions in warn.

Thanks for testing these and letting us know.

greg k-h
