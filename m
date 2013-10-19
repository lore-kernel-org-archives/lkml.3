Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3JSEtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 00:49:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3JSEtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 00:49:05 -0400
Date: Fri, 18 Oct 2013 21:49:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/11] 3.4.67-stable review
Message-ID: <20131019044950.GC14996@kroah.com>
References: <20131018195049.069623827@linuxfoundation.org>
 <5261FF5B.9000403@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5261FF5B.9000403@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 09:41:15PM -0600, Shuah Khan wrote:
> On 10/18/2013 01:53 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.67 release.
> > There are 11 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Oct 20 19:50:39 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.67-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patch applied cleanly 	 yes
> Compile testing          passed
> Boot testing 	         passed
> dmesg regression testing passed
> Cross-compile testing    passed
> 
> dmesgs look good. No regressions compared to the previous dmesgs for 
> this release. dmesg emerg, crit, alert, err are clean. No regressions
> in warn.

Thanks for testing and letting me know.

greg k-h
