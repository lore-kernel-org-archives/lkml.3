Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaBEW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:26:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaBEW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:26:22 -0500
Date: Wed, 5 Feb 2014 14:27:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 000/140] 3.13.2-stable review
Message-ID: <20140205222729.GB22532@kroah.com>
References: <20140204211036.967663852@linuxfoundation.org>
 <52F2A1DE.4060009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F2A1DE.4060009@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 01:41:02PM -0700, Shuah Khan wrote:
> On 02/04/2014 02:09 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.13.2 release.
> >There are 140 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Feb  6 21:10:18 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.2-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Patch applied cleanly. boot tests passed on all test systems. No dmesg
> regressions: emerg, crit, alert, err are clean. No regressions in warn.

Thanks for testing all of these and letting me know.

> Minor Note: git apply --index complained about extra white space at the end
> of patch file. patch -p1 worked just fine.

That came from an upstream patch, I didn't "clean" it up any.

thanks,

greg k-h
