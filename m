Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3GBSz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:55:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3GBSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:55:27 -0400
Date: Tue, 2 Jul 2013 11:55:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/8] 3.0.85-stable review
Message-ID: <20130702185526.GC7857@kroah.com>
References: <20130701200232.909858308@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6173432A@sisaex02sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6173432A@sisaex02sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 06:46:10PM +0000, Shuah Khan wrote:
> On 07/01/2013 03:08 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.85 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Jul  3 19:59:07 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.85-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Patches applied cleanly to 3.0.84, 3.4.51, and 3.9.8
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
>      (3.4.52-rc1, and 3.9.9-rc1)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
>      (3.0.85-rc1, 3.4.52-rc1, and 3.9.9-rc1)
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases.

Thanks for testing and letting us know.

greg k-h
