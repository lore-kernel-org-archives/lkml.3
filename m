Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3IFSq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:46:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3IFSqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:46:25 -0400
Date: Fri, 6 Sep 2013 11:46:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/7] 3.0.95-stable review
Message-ID: <20130906184624.GC5274@kroah.com>
References: <20130905202757.642048278@linuxfoundation.org>
 <522A1645.4060201@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522A1645.4060201@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 11:52:05AM -0600, Shuah Khan wrote:
> On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.0.95 release.
> >There are 7 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Sep  7 20:27:46 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.95-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> 3.0.95-rc1 applied cleanly to 3.0.94
> 
> Compiled and booted on the following systems:
> 
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for
> this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.

Thanks for testing and letting me know.

greg k-h
