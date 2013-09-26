Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3IZCoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3IZCoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:44:44 -0400
Date: Wed, 25 Sep 2013 19:45:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 000/117] 3.11.2-stable review
Message-ID: <20130926024546.GB24271@kroah.com>
References: <20130925001740.833541979@linuxfoundation.org>
 <52439B43.4000909@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52439B43.4000909@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 08:26:11PM -0600, Shuah Khan wrote:
> On 09/24/2013 06:17 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.11.2 release.
> > There are 117 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri Sep 27 00:16:31 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.2-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 3.11.2-rc1 applied cleanly to 3.11.1
> 
> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.

Thanks for testing all 4 of these and letting me know.

greg k-h
