Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaA2NET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:04:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaA2NES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:04:18 -0500
Date: Wed, 29 Jan 2014 05:05:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 00/10] 3.13.1-stable review
Message-ID: <20140129130531.GA2286@kroah.com>
References: <20140127201535.350372282@linuxfoundation.org>
 <52E7EBCF.1000009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E7EBCF.1000009@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:41:35AM -0700, Shuah Khan wrote:
> On 01/27/2014 01:17 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.13.1 release.
> > There are 10 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Jan 29 20:15:25 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.1-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patch testing - passed
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed - no regressions in emerg, crit, 
> alert, err are clean. No regressions in warn.

Wonderful, thanks for testing.

greg k-h
