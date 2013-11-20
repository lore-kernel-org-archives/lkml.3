Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3KTQ1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:27:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3KTQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:27:53 -0500
Date: Wed, 20 Nov 2013 08:28:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/12] 3.4.70-stable review
Message-ID: <20131120162819.GB5831@kroah.com>
References: <20131118184130.257996039@linuxfoundation.org>
 <528CD522.4020603@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CD522.4020603@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:28:34AM -0700, Shuah Khan wrote:
> On 11/18/2013 11:41 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.70 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Nov 20 18:41:11 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.70-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 3.4.70:
> 
> patches applied cleanly
> Compile test - passed
> Boot tests - passed
> 
> dmesg regression tests - passed
> [dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.]
> 
> Cross-compile testing - limited tests passed (alpha, arm, arm64, 
> blackfin, c6x, powerpc, sh, sparc, tile)
> 
> Test systems:
> Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

Thanks for testing all 4 kernels and letting me know they work.

greg k-h
