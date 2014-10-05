Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaJEUhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:37:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaJEUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:37:49 -0400
Date: Sun, 5 Oct 2014 13:37:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
Message-ID: <20141005203748.GB2528@kroah.com>
References: <20141003212933.458851516@linuxfoundation.org>
 <542F66FC.9040901@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542F66FC.9040901@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 08:18:20PM -0700, Guenter Roeck wrote:
> On 10/03/2014 02:26 PM, Greg Kroah-Hartman wrote:
> >---------------------------------
> >Note: This is a big stable release.  Mostly my fault for being on the
> >road last week, combined with an unusually large number of patches being
> >tagged for the stable tree.  Anyway, I've caught up with all pending
> >patches before 3.17-rc7, so if you have marked something for the stable
> >tree that I have not applied, or emailed the stable@v.k.o list asking
> >for a patch, that is not here, please let me know.
> >---------------------------------
> >
> >This is the start of the stable review cycle for the 3.16.4 release.
> >There are 357 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Oct  5 21:28:42 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 136 pass: 134 fail: 2
> Failed builds:
> 	arm:omap2plus_defconfig
> 	arm:multi_v7_defconfig
> 
> Qemu test results:
> 	total: 28 pass: 28 fail: 0
> 
> Build errors are the same as in 3.14, with the same culprit and fix.

Thanks, now added that patch to this queue.

greg k-h
