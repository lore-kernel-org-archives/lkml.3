Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaDVTki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:40:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaDVTkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:40:33 -0400
Date: Tue, 22 Apr 2014 12:36:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/32] 3.13.11-stable review
Message-ID: <20140422193600.GA5092@kroah.com>
References: <20140421021133.865086647@linuxfoundation.org>
 <53568F4C.2080800@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53568F4C.2080800@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 09:48:28AM -0600, Shuah Khan wrote:
> On 04/20/2014 08:13 PM, Greg Kroah-Hartman wrote:
> > ----------------
> >
> > Note, this is the LAST 3.13.y kernel I will be releasing.  It will be
> > end-of-life after this release, please move to 3.14.y at this time.
> >
> > ----------------
> >
> > This is the start of the stable review cycle for the 3.13.11 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Apr 23 02:10:46 UTC 2014.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.11-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Compiled and booted on my test systems. No dmesg regressions.

Thanks for testing and letting me know.

greg k-h
