Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3IZCoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:44:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZCoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:44:16 -0400
Date: Wed, 25 Sep 2013 19:45:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/28] 3.0.97-stable review
Message-ID: <20130926024517.GA24271@kroah.com>
References: <20130925000648.404447782@linuxfoundation.org>
 <52439A60.3080501@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52439A60.3080501@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 08:22:24PM -0600, Shuah Khan wrote:
> On 09/24/2013 06:07 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.0.97 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri Sep 27 00:05:34 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.97-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 3.0.97-rc1 applied with the following warning from line 103 to 3.0.96
> 
> patch-3.0.97-rc1:103: space before tab in indent.
>                          return -1;
> warning: 1 line adds whitespace errors.

Any hint as to what file that was for?

> Compiled and booted on the following systems:
> 
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.

Great, thanks for testing and letting me know.

greg k-h
