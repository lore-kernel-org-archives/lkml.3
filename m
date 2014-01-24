Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaAXQmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:42:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaAXQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:42:35 -0500
Date: Fri, 24 Jan 2014 08:43:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/23] 3.10.28-stable review
Message-ID: <20140124164326.GA26502@kroah.com>
References: <20140123183859.635713053@linuxfoundation.org>
 <52E28451.7070306@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E28451.7070306@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:18:41AM -0700, Shuah Khan wrote:
> On 01/23/2014 11:39 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.28 release.
> >There are 23 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sat Jan 25 18:38:43 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.28-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Patch testing - passed
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed - no regressions in emerg, crit, alert,
> err are clean. No regressions in warn.

Thanks for testing both of these and letting me know.

greg k-h
