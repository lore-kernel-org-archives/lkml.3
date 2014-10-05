Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaJEUjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:39:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaJEUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:38:59 -0400
Date: Sun, 5 Oct 2014 13:38:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
Message-ID: <20141005203858.GD2528@kroah.com>
References: <20141003212933.458851516@linuxfoundation.org>
 <87a95ctf9m.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a95ctf9m.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 05:23:17PM +0900, Satoru Takeuchi wrote:
> At Fri,  3 Oct 2014 14:26:26 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > ---------------------------------
> > Note: This is a big stable release.  Mostly my fault for being on the
> > road last week, combined with an unusually large number of patches being
> > tagged for the stable tree.  Anyway, I've caught up with all pending
> > patches before 3.17-rc7, so if you have marked something for the stable
> > tree that I have not applied, or emailed the stable@v.k.o list asking
> > for a patch, that is not here, please let me know.
> > ---------------------------------
> > 
> > This is the start of the stable review cycle for the 3.16.4 release.
> > There are 357 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Oct  5 21:28:42 UTC 2014.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.4-rc1.gz
> > and the diffstat can be found below.
> 
> Al 3.16.4-rc1, 3.14.20-rc1, and 3.10.56-rc1 passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> 
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
> 
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB

Thanks for testing all of these and letting me know.

greg k-h
