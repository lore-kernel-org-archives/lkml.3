Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3LSVZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:25:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab3LSVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:25:15 -0500
Date: Thu, 19 Dec 2013 13:25:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131219212517.GA17921@kroah.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <52B35B8D.3000901@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B35B8D.3000901@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 01:48:13PM -0700, Shuah Khan wrote:
> On 12/18/2013 02:10 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.12.6 release.
> >There are 118 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Patch applied cleanly
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed
> 
> dmesgs look good. No regressions compared to the previous dmesgs for this
> release. dmesg emerg, crit, alert, err are clean. No regressions in warn.

Thanks for testing all 3 of these and letting me know they work.

greg k-h
