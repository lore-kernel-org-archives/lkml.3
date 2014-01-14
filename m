Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaANXLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:11:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaANXLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:11:38 -0500
Date: Tue, 14 Jan 2014 15:12:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/62] 3.10.27-stable review
Message-ID: <20140114231216.GF7877@kroah.com>
References: <20140114002710.464561569@linuxfoundation.org>
 <52D5905B.1010103@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5905B.1010103@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:30:35PM -0700, Shuah Khan wrote:
> On 01/13/2014 05:26 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.27 release.
> >There are 62 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Thu Jan 16 00:26:56 UTC 2014.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.27-rc1.gz
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
> dmesg regression testing - passed
> 
> Test systems
> 
> Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> Dell OptiPlex 790 Intel(R) Core(TM) i5-2400
> 
> Detailed test status
> 
> Patches applied cleanly
> 
> dmesgs look good. No regressions compared to the previous dmesgs for this
> release. dmesg emerg, crit, alert, err are clean. No regressions in warn.

Thanks for testing all 3 of these and letting me know.

greg k-h
