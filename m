Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3JQRIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:08:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3JQRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:08:03 -0400
Date: Thu, 17 Oct 2013 10:08:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/50] 3.11.6-stable review
Message-ID: <20131017170802.GA27458@kroah.com>
References: <20131016174358.335646140@linuxfoundation.org>
 <526015BE.1020404@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526015BE.1020404@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:52:14AM -0600, Shuah Khan wrote:
> On 10/16/2013 11:44 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.11.6 release.
> >There are 50 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Fri Oct 18 17:43:24 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.6-rc1.gz
> >and the diffstat can be found below.
> >
> >thanks,
> >
> >greg k-h
> >
> 
> 3.11.6
> 
> Patch applied cleanly - yes
> Compile testing - passed
> Boot testing - passed
> dmesg regression testing - passed
> 
> dmesgs look good. No regressions compared to the previous dmesgs for
> this release. dmesg emerg, crit, alert, err are clean. No
> regressions in warn.
> 

Thanks for testing this, and 3.10.17 and letting me know it's all
working properly.

greg k-h
