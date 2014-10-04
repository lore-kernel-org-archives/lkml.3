Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaJDBnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 21:43:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaJDBm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 21:42:58 -0400
Date: Fri, 3 Oct 2014 18:42:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
Message-ID: <20141004014201.GA13873@kroah.com>
References: <20141003212933.458851516@linuxfoundation.org>
 <542F403F.1010807@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542F403F.1010807@osg.samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 06:33:03PM -0600, Shuah Khan wrote:
> On 10/03/2014 03:26 PM, Greg Kroah-Hartman wrote:
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
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Looking better than the previous with clean dmesg err
> 
> drm:ivb_err_int_handlererrors I was seeing went away.
> Must be changes in drivers/gpu/drm/i915

Thanks for testing all of these and letting me know.

greg k-h
