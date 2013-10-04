Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3JDCoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:44:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JDCoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:44:00 -0400
Date: Thu, 3 Oct 2013 19:38:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/16] 3.4.65-stable review
Message-ID: <20131004023812.GC3417@kroah.com>
References: <20131003040445.523176877@linuxfoundation.org>
 <524E0AA5.3080604@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524E0AA5.3080604@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:24:05PM -0600, Shuah Khan wrote:
> On 10/02/2013 10:05 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.4.65 release.
> >There are 16 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Oct  5 04:04:34 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Patch testing: 3.4.65-rc1-rc1 patch applied with white-space
> warnings and 3.4.65-rc2 applied cleanly.
> 
> Tested 3.4.65-rc1 and 3.4.65-rc2.
> Compile testing: 3.4.65-rc1 and 3.4.65-rc2. Passed
> Boot testing: 3.4.65-rc1 and 3.4.65-rc2. Passed
> dmesg regression testing: passed. dmesgs look good. No regressions
> compared to the previous dmesgs for this release. dmesg emerg, crit,
> alert, err are clean. No regressions in warn.

Thanks for testing both of these.

greg k-h
