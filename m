Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaHFOVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:21:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaHFOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:21:23 -0400
Date: Wed, 6 Aug 2014 07:20:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/42] 3.15.9-stable review
Message-ID: <20140806142049.GA13024@kroah.com>
References: <20140805181321.018370988@linuxfoundation.org>
 <53E16394.7090400@samsung.com>
 <20140805232704.GA26196@kroah.com>
 <87mwbh971q.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwbh971q.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 08:44:17PM +0900, Satoru Takeuchi wrote:
> At Tue, 5 Aug 2014 16:27:04 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > On Tue, Aug 05, 2014 at 05:07:00PM -0600, Shuah Khan wrote:
> > > On 08/05/2014 12:13 PM, Greg Kroah-Hartman wrote:
> > > >This is the start of the stable review cycle for the 3.15.9 release.
> > > >There are 42 patches in this series, all will be posted as a response
> > > >to this one.  If anyone has any issues with these being applied, please
> > > >let me know.
> > > >
> > > >Responses should be made by Thu Aug  7 18:13:05 UTC 2014.
> > > >Anything received after that time might be too late.
> > > >
> > > >The whole patch series can be found in one patch at:
> > > >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.9-rc1.gz
> > > >and the diffstat can be found below.
> > > >
> > > >thanks,
> > > >
> > > >greg k-h
> > > >
> > > 
> > > Compiled and booted on my test system. No dmesg regressions
> > > compared to previous 3.15.8
> > 
> > Thanks for testing all of these and letting me know.
> > 
> > greg k-h
> 
> All 3.15.9-rc1, 3.14.16-rc1, 3.10.52-rc1, and 3.4.102-rc1 passed my test.

Wonderful, thanks for testing.

greg k-h
