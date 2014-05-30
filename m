Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbaEaBIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:08:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbaEaBIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:08:53 -0400
Date: Fri, 30 May 2014 16:14:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
Message-ID: <20140530231413.GA25854@kroah.com>
References: <20140529043049.661315084@linuxfoundation.org>
 <20140529155923.61a11b69@notabene.brown>
 <20140529141823.GA28074@kroah.com>
 <5388DF4C.6000205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5388DF4C.6000205@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 01:43:08PM -0600, Shuah Khan wrote:
> On 05/29/2014 08:18 AM, Greg Kroah-Hartman wrote:
> >On Thu, May 29, 2014 at 03:59:23PM +1000, NeilBrown wrote:
> >>On Wed, 28 May 2014 21:32:19 -0700 Greg Kroah-Hartman
> >><gregkh@linuxfoundation.org> wrote:
> >>
> >>>This is the start of the stable review cycle for the 3.14.5 release.
> >>>There are 140 patches in this series, all will be posted as a response
> >>>to this one.  If anyone has any issues with these being applied, please
> >>>let me know.
> >>>
> >>>Responses should be made by Sat May 31 04:30:12 UTC 2014.
> >>>Anything received after that time might be too late.
> >>>
> >>>The whole patch series can be found in one patch at:
> >>>	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.5-rc1.gz
> >>>and the diffstat can be found below.
> >>>
> >>
> 
> Compiled and booted on my test systems. No dmesg regressions.

Thanks for testing.

greg k-h
