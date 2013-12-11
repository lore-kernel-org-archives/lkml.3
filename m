Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LKB7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:59:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:59:19 -0500
Date: Tue, 10 Dec 2013 18:00:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 00/62] 3.12.5-stable review
Message-ID: <20131211020052.GA15638@kroah.com>
References: <20131210080057.415644748@linuxfoundation.org>
 <52A7C4AB.1020803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7C4AB.1020803@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 06:49:31PM -0700, Shuah Khan wrote:
> On 12/10/2013 01:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.12.5 release.
> > There are 62 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Dec 12 08:00:42 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.5-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Patch applied cleanly
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions in 
> warn.
> 
> Test systems
> 
>      Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
>      HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>      Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

Thanks for testing all 3 and letting me know all is good.

greg k-h
