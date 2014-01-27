Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaA0Rao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:30:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0Ran (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:30:43 -0500
Date: Mon, 27 Jan 2014 09:31:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/12] 3.4.78-stable review
Message-ID: <20140127173147.GA32396@kroah.com>
References: <20140126030451.934281002@linuxfoundation.org>
 <52E694E5.6080808@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E694E5.6080808@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 10:18:29AM -0700, Shuah Khan wrote:
> On 01/25/2014 08:05 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.78 release.
> > There are 12 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.78-rc1.gz
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

Great, thanks for testing and letting me know.

greg k-h
