Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaDLB4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:56:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaDLB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:56:12 -0400
Date: Fri, 11 Apr 2014 18:59:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/23] 3.14.1-stable review
Message-ID: <20140412015901.GC6479@kroah.com>
References: <20140411161200.236939691@linuxfoundation.org>
 <53487EEF.6070507@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53487EEF.6070507@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 05:46:55PM -0600, Shuah Khan wrote:
> On 04/11/2014 10:11 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.14.1 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Apr 13 16:11:46 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.1-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Compiled and booted on my test systems. No dmesg regressions.

Thanks for testing all 3 of these and letting me know.

greg k-h
